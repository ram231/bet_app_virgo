import 'package:bet_app_virgo/models/models.dart';
import 'package:bet_app_virgo/utils/date_format.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hits_report_event.dart';
part 'hits_report_state.dart';

class HitsReportBloc extends Bloc<HitsReportEvent, HitsReportState> {
  HitsReportBloc({
    STLHttpClient? httpClient,
    required this.user,
  })  : _httpClient = httpClient ?? STLHttpClient(),
        super(HitsReportInitial()) {
    on<FetchHitReportsEvent>(_onFetch);
  }

  final STLHttpClient _httpClient;

  final UserAccount user;

  Map<String, String> get cashierIdParam => {
        'filter[show_all_or_not]': "${user.id},${user.type}",
      };

  void _onFetch(FetchHitReportsEvent event, Emitter emit) async {
    emit(HitsReportLoading());

    final result = await _httpClient
        .get<List>("$adminEndpoint/winning-hits", queryParams: {
      'filter[from_this_day]': YEAR_MONTH_DAY.format(event.dateTime),
      ...cashierIdParam,
    }, onSerialize: (json) {
      return json['data'];
    });
    final draws = result.map((e) => WinningHitsResult.fromMap(e)).toList();
    emit(HitsReportLoaded(draws: draws, drawDate: event.dateTime));
  }
}
