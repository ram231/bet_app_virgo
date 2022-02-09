import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'grand_total_draws_state.dart';

class GrandTotalDrawsCubit extends Cubit<GrandTotalDrawsState> {
  GrandTotalDrawsCubit({
    STLHttpClient? httpClient,
    required this.user,
  })  : _httpClient = httpClient ?? STLHttpClient(),
        super(GrandTotalDrawsState());

  final STLHttpClient _httpClient;

  final UserAccount user;

  Map<String, String> get cashierIdParam => {
        'filter[show_all_or_not]': "${user.id},${user.type}",
      };

  void fetch({DateTime? fromDate, DateTime? toDate}) async {
    final startDate = YEAR_MONTH_DAY.format(
      fromDate ?? DateTime.now(),
    );

    final endDate = YEAR_MONTH_DAY.format(
      toDate ?? DateTime.now(),
    );

    emit(state.copyWith(isLoading: true));

    try {
      final result = await _httpClient.get(
        '$adminEndpoint/winning-hits',
        queryParams: {
          'filter[from_this_day]': startDate,
          'filter[to_this_day]': endDate,
          ...cashierIdParam,
        },
        onSerialize: (json) => (json['data'] as List),
      );
      final items = result.map((e) => WinningHitsResult.fromMap(e)).toList();
      emit(state.copyWith(draws: items));
    } catch (e) {
      emit(state.copyWith(error: throwableDioError(e)));
      addError(e);
    }
  }
}
