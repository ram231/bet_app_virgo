import 'package:bet_app_virgo/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'grand_total_state.dart';

class GrandTotalCubit extends Cubit<GrandTotalState> {
  GrandTotalCubit({STLHttpClient? httpClient})
      : _httpClient = httpClient ?? STLHttpClient(),
        super(GrandTotalInitial());

  final STLHttpClient _httpClient;

  /// [fromDate] format - YYYY-MM-DD
  ///
  /// [toDate] format - YYYY-MM-DD
  void fetch({
    String? fromDate,
    String? toDate,
  }) async {
    try {
      emit(GrandTotalLoading());
      final result = await _httpClient.get('$adminEndpoint/bets/grand-total',
          queryParams: {
            'fromDate': fromDate,
            'toDate': toDate,
          },
          onSerialize: (json) => json);
      final grandTotal = GrandTotalLoaded(
        betAmount: result['bet_amount'],
        readableBetAmount: result['readable_bet_amount'],
        hits: result['hits'],
      );
      emit(grandTotal);
    } catch (e) {
      debugPrint("$e");
      addError(e);
    }
  }
}
