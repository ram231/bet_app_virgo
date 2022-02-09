import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/http_client.dart';

part 'bet_cancel_event.dart';
part 'bet_cancel_state.dart';

class BetCancelBloc extends Bloc<BetCancelEvent, BetCancelState> {
  BetCancelBloc({
    required this.cashierId,
    STLHttpClient? httpClient,
  })  : _http = httpClient ?? STLHttpClient(),
        super(BetCancelState()) {
    on<BetCancelFetchEvent>(_onFetch);
  }
  final String cashierId;
  final STLHttpClient _http;
  void _onFetch(
    BetCancelFetchEvent event,
    Emitter<BetCancelState> emit,
  ) async {
    try {
      emit(BetCancelState(status: BetCancelStatus.loading));
      final result = await _http.get(
        '$adminEndpoint/bets',
        onSerialize: (json) => json['data'] as List,
      );
      final lists = result.map((e) => BetResult.fromMap(e)).toList();
      emit(BetCancelState(
        status: BetCancelStatus.success,
        items: lists,
        searchItem: event.searchItem,
      ));
    } catch (e) {
      addError(e);
      emit(BetCancelState(
        status: BetCancelStatus.failed,
        error: throwableDioError(e),
      ));
    }
  }
}
