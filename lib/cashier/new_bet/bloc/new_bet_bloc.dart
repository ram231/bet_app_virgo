import 'dart:async';

import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../models/models.dart';
import '../dto/append_bet_dto.dart';

part 'new_bet_event.dart';
part 'new_bet_state.dart';

class NewBetBloc extends Bloc<NewBetEvent, NewBetLoaded> {
  NewBetBloc({
    required this.cashier,
    STLHttpClient? httpClient,
  })  : _httpClient = httpClient ?? STLHttpClient(),
        super(NewBetLoaded(
          cashier: cashier,
        )) {
    on<AddNewBetEvent>(_onAppend);
    on<InsertNewBetEvent>(_onInsert);
    on<ResetBetEvent>(_onReset);
    on<SubmitBetEvent>(_onSubmit);
    on<ConnectPrinterEvent>(_connectPrinter);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  final UserAccount cashier;

  Map<String, dynamic> get cashierIdParam => {'filter[user_id': cashier.id};

  final STLHttpClient _httpClient;

  Future<NewBetLoaded> _onValidateEvent(AppendBetDTO dto) async {
    final rawState = state.copyWith(items: [
      ...state.items,
      dto.copyWith(
        winAmount: dto.betAmount * dto.winAmount,
      )
    ]);
    try {
      final result = await _httpClient.post(
        '$adminEndpoint/bets/append/${dto.betNumber}',
        queryParams: cashierIdParam,
      );
      if (result != null) {
        if (result is String) {
          return rawState;
        }
        if (result is Map<String, dynamic>) {
          final rawAmount = result['winning_amount'];
          final winAmount = rawAmount is String
              ? double.parse(rawAmount)
              : rawAmount as double;
          return state.copyWith(
            items: [...state.items, dto.copyWith(winAmount: winAmount)],
          );
        }
      }
    } catch (e) {
      addError(e);
      if (e is DioError) {
        final err = e.response?.data['errors']['message'][0];
        return state.copyWith(
          error: err ?? '',
        );
      }
    }
    return rawState;
  }

  void _onInsert(InsertNewBetEvent event, Emitter emit) {
    emit(state.copyWith(
      betAmount: event.betAmount,
      branchId: event.branchId,
      winAmount: event.winAmount,
      drawTypeBet: event.drawTypeBet,
      betNumber: event.betNumber,
      cashier: event.cashier,
    ));
  }

  void _onAppend(AddNewBetEvent event, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    final itemExist = state.items.where(
      (element) => event.dto.betNumber == element.betNumber,
    );
    if (itemExist.isNotEmpty) {
      emit(state.copyWith(error: "Bet Number already exists"));
      return;
    }
    final result = await _onValidateEvent(event.dto);
    emit(result);
  }

  void _onReset(ResetBetEvent event, Emitter emit) {
    emit(state.copyWith(
      items: [],
    ));
  }

  void _onSubmit(
    SubmitBetEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final result = await submitBet();
      final cashier = state.cashier;
      emit(
        state.copyWith(
          result: result,
          status: PrintStatus.printing,
        ),
      );
      if (cashier != null) {
        await _printReceipt(cashier, result);
      }

      emit(state.copyWith(
        status: PrintStatus.done,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: "$e"));
      addError(e);
      print(e);
    }
  }

  Future<List<BetResult>> submitBet() async {
    final items = state.items;
    final cashierId = cashier.id;
    final branchId = cashier.branchId;
    final request = items.map((e) {
      final data = {
        'user_id': cashierId,
        'branch_id': branchId,
        'bet_amount': e.betAmount,
        'bet_number': e.betNumber,
        'draw_id': e.drawTypeBet?.id,
        'prize': e.winAmount,
      };
      return _httpClient.post(
        '$adminEndpoint/bets',
        body: data,
        onSerialize: (json) => BetResult.fromMap(json),
        queryParams: cashierIdParam,
      );
    }).toList();

    final result = await Future.wait(request);
    return result;
  }

  void _connectPrinter(ConnectPrinterEvent event, Emitter emit) async {
    emit(state.copyWith(isConnected: event.isConnected));
  }

  Future<bool> get isConnected async {
    final isConnected =
        (await BlueThermalPrinter.instance.isConnected) ?? false;
    final isOn = (await BlueThermalPrinter.instance.isOn) ?? false;

    final devices = (await BlueThermalPrinter.instance.getBondedDevices());

    return isConnected && isOn && devices.first.connected;
  }

  Future<bool> _printReceipt(
    UserAccount cashier,
    List<BetResult> result,
  ) async {
    try {
      final receipt = await _httpClient.post('$adminEndpoint/receipts',
          body: {
            "user_id": cashier.id,
            "bet_ids": result.map((e) => e.id).toList(),
          },
          onSerialize: (json) => BetReceipt.fromMap(json));

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
      await Future.wait(result.map((e) {
        return BlueThermalPrinter.instance.print4Column(
          '${e.betNumber}',
          "${e.betAmount?.toInt()}",
          "${e.prize}",
          "${e.draw?.id ?? 'N/A'}",
          0,
        );
      }));
      await BlueThermalPrinter.instance.printCustom(
        "--------------------------------",
        1,
        0,
      );
      final total = result.fold<double>(
        0,
        (previousValue, element) => previousValue + (element.betAmount ?? 0),
      );
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printCustom(
        "Total:$total",
        1,
        1,
      );

      await BlueThermalPrinter.instance.printCustom(
        "Receipt: ${receipt.receiptNo ?? 'N/A'}",
        1,
        1,
      );

      await BlueThermalPrinter.instance.printCustom(
        "STRICTLY!!! No ticket no claim. ",
        1,
        1,
      );
      await BlueThermalPrinter.instance.printCustom(
        "${result.first.branch?.name ?? 'Unknown'}",
        1,
        1,
      );
      final data = "${receipt.receiptNo}";
      await await BlueThermalPrinter.instance.printQRcode(
        data,
        200,
        200,
        1,
      );
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
      await BlueThermalPrinter.instance.printNewLine();
      return true;
    } catch (e) {
      print("$e");
      addError(e);
      return false;
    }
  }
}
