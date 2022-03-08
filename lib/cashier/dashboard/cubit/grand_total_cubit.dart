import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:bet_app_virgo/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../models/models.dart';

part 'grand_total_state.dart';

class GrandTotalCubit extends Cubit<GrandTotalState> {
  GrandTotalCubit({
    STLHttpClient? httpClient,
    required this.user,
  })  : _httpClient = httpClient ?? STLHttpClient(),
        super(GrandTotalInitial());

  final STLHttpClient _httpClient;
  final UserAccount user;

  Map<string, dynamic> get cashierIdParam =>
      {'filter[show_all_or_not]': "${user.id},${user.type}"};

  void fetch({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    if (fromDate == null) {
      fromDate = DateTime.now();
    }
    if (toDate == null) {
      toDate = DateTime.now();
    }
    final startDate = YEAR_MONTH_DAY.format(
      fromDate,
    );
    final endDate = YEAR_MONTH_DAY.format(
      toDate,
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
        fromDate: fromDate,
        toDate: toDate,
        readableHits: result['readable_hits'] ?? '',
      );
      emit(grandTotal);
    } catch (e) {
      debugPrint("$e");

      final grandTotal = GrandTotalLoaded(
        betAmount: 0,
        readableBetAmount: "P 0.00",
        hits: 0,
        fromDate: fromDate,
        toDate: toDate,
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

  void fetchAdmin({DateTime? fromDate, DateTime? toDate}) async {
    if (fromDate == null) {
      fromDate = DateTime.now();
    }
    if (toDate == null) {
      toDate = DateTime.now();
    }
    final startDate = YEAR_MONTH_DAY.format(
      fromDate,
    );
    final endDate = YEAR_MONTH_DAY.format(
      toDate,
    );
    try {
      emit(GrandTotalLoading());
      final List result = await _httpClient.get(
        '$adminEndpoint/bets/grand-total-per-cashier',
        queryParams: {
          'from_date': startDate,
          'to_date': endDate,
          ...cashierIdParam,
          'is_winner': true,
        },
      );

      final list = result.map((json) {
        return AdminGrandTotal.fromMap(json);
      }).toList();
      emit(
        GrandTotalAdminLoaded(
          items: list,
          fromDate: fromDate,
          toDate: toDate,
        ),
      );
    } catch (e) {
      emit(GrandTotalAdminLoaded(
        fromDate: fromDate,
        toDate: toDate,
        error: throwableDioError(e),
      ));
    }
  }

  void refetchAdmin() {
    final _state = state;
    if (_state is GrandTotalAdminLoaded) {
      emit(GrandTotalLoading());
      final fromDate = _state.fromDate;
      final toDate = _state.toDate;
      fetchAdmin(
        fromDate: fromDate,
        toDate: toDate,
      );
      return;
    }
    emit(GrandTotalLoading());
    fetchAdmin();
  }
}
