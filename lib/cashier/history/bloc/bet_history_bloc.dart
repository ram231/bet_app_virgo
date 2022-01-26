import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

part 'bet_history_event.dart';
part 'bet_history_state.dart';

class BetHistoryBloc extends Bloc<BetHistoryEvent, BetHistoryState> {
  BetHistoryBloc({STLHttpClient? httpClient})
      : _httpClient = httpClient ?? STLHttpClient(),
        super(BetHistoryInitial()) {
    on<FetchBetHistoryEvent>(_onFetch);
  }
  final STLHttpClient _httpClient;
  void _onFetch(FetchBetHistoryEvent event, Emitter emit) async {
    try {
      emit(BetHistoryLoading());
      final result = await _httpClient.get<List>("$adminEndpoint/bets",
          queryParams: {
            'filter[from_this_day]':
                DateFormat("yyyy-MM-DD").format(event.dateTime),
          },
          onSerialize: (json) => json['data']);
      debugPrint("$result");
      final list = result.map((e) => BetResult.fromMap(e)).toList();
      emit(BetHistoryLoaded(bets: list, date: event.dateTime));
    } catch (e) {
      emit(BetHistoryError(error: e));
      debugPrint("$e");
    }
  }
}
