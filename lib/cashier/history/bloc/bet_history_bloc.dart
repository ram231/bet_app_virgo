import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

part 'bet_history_event.dart';
part 'bet_history_state.dart';

class BetHistoryBloc extends Cubit<BetHistoryState> {
  BetHistoryBloc({STLHttpClient? httpClient})
      : _httpClient = httpClient ?? STLHttpClient(),
        super(BetHistoryState(date: DateTime.now()));
  final STLHttpClient _httpClient;
  void fetch({DateTime? fromDate}) async {
    emit(state.copyWith(isLoading: true));
    final startDate = fromDate ?? state.date;
    try {
      final result = await _httpClient.get<List>("$adminEndpoint/bets",
          queryParams: {
            'filter[from_this_day]': DateFormat.yMd().format(startDate),
          },
          onSerialize: (json) => json['data']);
      debugPrint("$result");
      final list = result.map((e) => BetResult.fromMap(e)).toList();
      emit(BetHistoryState(bets: list, date: startDate));
    } catch (e) {
      emit(state.copyWith(error: "$e"));
      debugPrint("$e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await _httpClient.post("$adminEndpoint/bets/cancel/${id}");
      fetch();
    } catch (e) {
      emit(state.copyWith(error: '$e'));
    }
  }

  Future<void> cancelReceipt(int receiptNo) async {
    try {
      await _httpClient.post('$adminEndpoint/receipts/no/$receiptNo');
      fetch();
    } catch (e) {
      emit(state.copyWith(error: "$e"));
    }
  }
}
