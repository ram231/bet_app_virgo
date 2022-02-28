import 'dart:io';

import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

part 'bet_history_event.dart';
part 'bet_history_state.dart';

// this is now receipt history
class BetHistoryBloc extends Cubit<BetHistoryState> {
  BetHistoryBloc({
    STLHttpClient? httpClient,
    required this.user,
  })  : _httpClient = httpClient ?? STLHttpClient(),
        super(BetHistoryState(date: DateTime.now()));

  final STLHttpClient _httpClient;

  final UserAccount user;

  Map<String, dynamic> get cashierIdParam => {
        'filter[show_all_or_not]': "${user.id},${user.type}",
      };
  void onErr(Object err) {
    emit(state.copyWith(error: "$err"));
  }

  void searchReceipt(String receiptNo) {
    if (receiptNo.isEmpty) {
      emit(state.copyWith());
    }
    final receipt = state.bets
        .where((element) => element.receiptNo?.contains(receiptNo) ?? false)
        .toList();
    if (receipt.isNotEmpty) {
      emit(state.copyWith(searchResult: receipt));
      return;
    }
    emit(state.copyWith(error: "'${receiptNo}' not found"));
  }

  void rePrintReceipt(BetReceipt receipts) async {
    try {
      final bytes = await rootBundle.load("images/print_logo.jpg");
      final dir = (await getApplicationDocumentsDirectory()).path;
      final buffer = bytes.buffer;
      final file = await File("$dir/print_logo.png").writeAsBytes(
          buffer.asUint8List(bytes.offsetInBytes, buffer.lengthInBytes));
      await BlueThermalPrinter.instance.printImage(
        file.path,
      );

      /// DATE FORMAT:  MM/DD/yyyy H:MM A
      final datePrinted = DateFormat.yMd().add_jm().format(DateTime.now());
      await BlueThermalPrinter.instance.printCustom(
        "Receipt Date: $datePrinted",
        1,
        0,
      );
      await BlueThermalPrinter.instance.printCustom(
        "--------------------------------",
        1,
        0,
      );
      await BlueThermalPrinter.instance.print4Column(
        "Bet",
        "Amount",
        "Prize",
        "Draw",
        1,
      );
      await Future.wait(receipts.bets.map((e) {
        return BlueThermalPrinter.instance.print4Column(
          '${e.betNumber}',
          "${e.betAmount}",
          "${e.prize}",
          "${e.drawId}",
          0,
        );
      }));
      await BlueThermalPrinter.instance.printCustom(
        "--------------------------------",
        1,
        0,
      );

      await BlueThermalPrinter.instance.printCustom(
        "STRICTLY!!! No ticket no claim. ",
        1,
        1,
      );
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
    } catch (e) {
      addError(e);
      emit(state.copyWith(error: "$e"));
    }
  }

  void fetch({DateTime? fromDate}) async {
    emit(state.copyWith(isLoading: true));

    final startDate = fromDate ?? state.date;

    try {
      final result = await _httpClient.get<List>("$adminEndpoint/receipts",
          queryParams: {
            'filter[from_this_day]': YEAR_MONTH_DAY.format(startDate),
            ...cashierIdParam,
          },
          onSerialize: (json) => json['data']);
      final computedBet = await compute(computeBetReceipt, result);
      debugPrint("$result");

      emit(BetHistoryState(bets: computedBet, date: startDate));
    } catch (e) {
      emit(state.copyWith(error: throwableDioError(e)));
      debugPrint("$e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await _httpClient.post(
        "$adminEndpoint/bets/cancel/${id}",
        queryParams: cashierIdParam,
      );

      fetch();
    } catch (e) {
      emit(state.copyWith(error: throwableDioError(e)));
    }
  }

  Future<void> cancelReceipt(
      {required String receiptNo, required int cashierId}) async {
    try {
      await _httpClient.post(
        '$adminEndpoint/receipts/no/$receiptNo',
        body: {
          "user_id": cashierId,
          "status": "I",
        },
        queryParams: cashierIdParam,
      );

      fetch();
    } catch (e) {
      emit(state.copyWith(error: throwableDioError(e)));
      addError(e);
    }
  }
}
