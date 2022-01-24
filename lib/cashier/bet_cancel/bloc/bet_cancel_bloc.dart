import 'package:bet_app_virgo/cashier/bet_cancel/repository/bet_cancel_repository.dart';
import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'bet_cancel_event.dart';
part 'bet_cancel_state.dart';

class BetCancelBloc extends Bloc<BetCancelEvent, BetCancelState> {
  BetCancelBloc({BetCancelInterface? repository})
      : _repository = repository ?? BetCancelRepository(),
        super(BetCancelState()) {
    on<BetCancelFetchEvent>(_onFetch);
  }
  final BetCancelInterface _repository;
  void _onFetch(
    BetCancelFetchEvent event,
    Emitter<BetCancelState> emit,
  ) async {
    try {
      emit(BetCancelState(status: BetCancelStatus.loading));

      final result = await _repository.fetch(search: event.searchItem);

      emit(BetCancelState(
        status: BetCancelStatus.success,
        items: result,
        searchItem: event.searchItem,
      ));
    } catch (e) {
      addError(e);
      emit(BetCancelState(
        status: BetCancelStatus.failed,
        error: e,
      ));
    }
  }
}
