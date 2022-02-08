import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:bet_app_virgo/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'grand_total_state.dart';

class GrandTotalCubit extends Cubit<GrandTotalState> {
  GrandTotalCubit({
    STLHttpClient? httpClient,
    required this.cashierId,
  })  : _httpClient = httpClient ?? STLHttpClient(),
        super(GrandTotalInitial());

  final STLHttpClient _httpClient;
  final String cashierId;

  Map<string, String> get cashierIdParam => {'filter[user_id]': cashierId};

  /// [fromDate] format - yyyy-MM-DD
  ///
  /// [toDate] format - yyyy-MM-DD
  void fetch({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final startDate = YEAR_MONTH_DAY.format(
      fromDate ?? DateTime.now(),
    );
    final endDate = YEAR_MONTH_DAY.format(
      toDate ?? DateTime.now(),
    );
    try {
      emit(GrandTotalLoading());
      final result = await _httpClient.get('$adminEndpoint/bets/grand-total',
          queryParams: {
            'from_date': startDate,
            'to_date': endDate,
            ...cashierIdParam,
          },
          onSerialize: (json) => json);
      final rawAmount = result['bet_amount'];
      final rawHits = result['hits'];
      final amount = rawAmount is String
          ? int.parse(rawAmount.split(".").first)
          : rawAmount as int;
      final hits = rawHits is String
          ? int.parse(rawHits.split(".").first)
          : rawHits as int;
      final grandTotal = GrandTotalLoaded(
        betAmount: amount,
        readableBetAmount: result['readable_bet_amount'],
        hits: hits,
        fromDate: fromDate ?? DateTime.now(),
        toDate: toDate ?? DateTime.now(),
        readableHits: result['readable_hits'] ?? '',
      );
      emit(grandTotal);
    } catch (e) {
      debugPrint("$e");

      final grandTotal = GrandTotalLoaded(
        betAmount: 0,
        readableBetAmount: "P 0.00",
        hits: 0,
        fromDate: fromDate ?? DateTime.now(),
        toDate: toDate ?? DateTime.now(),
        error: throwableDioError(e),
      );
      emit(grandTotal);
      addError(e);
    }
  }

  void refetch() {
    final _state = state;
    if (_state is GrandTotalLoaded) {
      emit(GrandTotalLoading());
      final fromDate = _state.fromDate;
      final toDate = _state.toDate;
      fetch(
        fromDate: fromDate,
        toDate: toDate,
      );
      return;
    }
    emit(GrandTotalLoading());
    fetch();
  }
}
