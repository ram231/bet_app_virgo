import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'bet_history_event.dart';
part 'bet_history_state.dart';

// this is now receipt history
class BetHistoryBloc extends Cubit<BetHistoryState> {
  BetHistoryBloc({STLHttpClient? httpClient})
      : _httpClient = httpClient ?? STLHttpClient(),
        super(BetHistoryState(date: DateTime.now()));
  final STLHttpClient _httpClient;
  void fetch({DateTime? fromDate}) async {
    emit(state.copyWith(isLoading: true));
    final startDate = fromDate ?? state.date;
    try {
      final result = await _httpClient.get<List>("$adminEndpoint/receipts",
          queryParams: {
            'filter[from_this_day]': YEAR_MONTH_DAY.format(startDate),
          },
          onSerialize: (json) => json['data']);
      debugPrint("$result");
      final list = result.map((e) => BetReceipt.fromMap(e)).toList();
      emit(BetHistoryState(bets: list, date: startDate));
    } catch (e) {
      if (e is DioError) {
        final err = e.response?.statusMessage ?? e.message;
        emit(state.copyWith(error: "$err"));
      } else {
        emit(state.copyWith(error: "$e"));
      }
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

  Future<void> cancelReceipt(
      {required String receiptNo, required int cashierId}) async {
    try {
      await _httpClient.post('$adminEndpoint/receipts/no/$receiptNo', body: {
        "cashier_id": cashierId,
        "status": "I",
      });
      fetch();
    } catch (e) {
      if (e is DioError) {
        final err = e.response?.data['errors'].toString() ?? e.message;
        emit(state.copyWith(error: "$err"));
      } else {
        emit(state.copyWith(error: "$e"));
      }
      addError(e);
    }
  }
}
