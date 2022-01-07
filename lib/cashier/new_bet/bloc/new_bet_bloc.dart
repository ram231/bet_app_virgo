import 'package:bet_app_virgo/models/draw.dart';
import 'package:bet_app_virgo/models/user_account.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../dto/append_bet_dto.dart';

part 'new_bet_event.dart';
part 'new_bet_state.dart';

class NewBetBloc extends Bloc<NewBetEvent, NewBetState> {
  NewBetBloc() : super(NewBetLoaded()) {
    on<AddNewBetEvent>(_onAppend);
    on<InsertNewBetEvent>(_onInsert);
    on<ResetBetEvent>(_onReset);
  }
  void _onInsert(InsertNewBetEvent event, Emitter emit) {
    final _state = state;
    if (_state is NewBetLoaded) {
      emit(_state.copyWith(
        betAmount: event.betAmount,
        branchId: event.branchId,
        winAmount: event.winAmount,
        drawTypeBet: event.drawTypeBet,
        betNumber: event.betNumber,
        cashier: event.cashier,
      ));
    }
  }

  void _onAppend(AddNewBetEvent event, Emitter emit) {
    final _state = state;
    if (_state is NewBetLoaded) {
      emit(_state.copyWith(items: [
        ..._state.items,
        event.dto.copyWith(
          winAmount: event.dto.betAmount * event.dto.winAmount,
        )
      ]));
    }
  }

  void _onReset(ResetBetEvent event, Emitter emit) {
    final _state = state;
    if (_state is NewBetLoaded) {
      emit(_state.copyWith(
        items: [],
      ));
    }
  }
}
