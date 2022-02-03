import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'grand_total_draws_state.dart';

class GrandTotalDrawsCubit extends Cubit<GrandTotalDrawsState> {
  GrandTotalDrawsCubit({STLHttpClient? httpClient})
      : _httpClient = httpClient ?? STLHttpClient(),
        super(GrandTotalDrawsState());
  final STLHttpClient _httpClient;
  void fetch({DateTime? fromDate, DateTime? toDate}) async {
    final startDate = YEAR_MONTH_DATE.format(
      fromDate ?? DateTime.now(),
    );
    final endDate = YEAR_MONTH_DATE.format(
      toDate ?? DateTime.now(),
    );
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _httpClient.get(
        '$adminEndpoint/winning-hits',
        queryParams: {
          'filter[from_this_day]': startDate,
          'filter[to_this_day]': endDate,
        },
        onSerialize: (json) => (json['data'] as List)
            .map((e) => WinningHitsResult.fromMap(e))
            .toList(),
      );
      emit(state.copyWith(draws: result));
    } catch (e) {
      if (e is DioError) {
        final error = e.response?.statusMessage ?? e.message;
        emit(state.copyWith(error: error));
      } else {
        emit(state.copyWith(error: "$e"));
      }
      addError(e);
    }
  }
}
