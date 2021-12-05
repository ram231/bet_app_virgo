import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
      final result = await _httpClient.get<List>("$adminEndpoint/bets",
          onSerialize: (json) => json['data']);
      debugPrint("$result");
      final list = result.map((e) => BetResult.fromMap(e)).toList();
      emit(BetHistoryLoaded(list));
    } catch (e) {
      debugPrint("$e");
    }
  }
}
