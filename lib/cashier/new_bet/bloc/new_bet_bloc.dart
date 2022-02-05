import 'package:bet_app_virgo/models/draw.dart';
import 'package:bet_app_virgo/models/user_account.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../dto/append_bet_dto.dart';

part 'new_bet_event.dart';
part 'new_bet_state.dart';

class NewBetBloc extends Bloc<NewBetEvent, NewBetLoaded> {
  NewBetBloc({
    required this.cashierId,
    STLHttpClient? httpClient,
  })  : _httpClient = httpClient ?? STLHttpClient(),
        super(NewBetLoaded()) {
    on<AddNewBetEvent>(_onAppend);
    on<InsertNewBetEvent>(_onInsert);
    on<ResetBetEvent>(_onReset);
  }
  final String cashierId;
  Map<String, String> get cashierIdParam => {'filter[cashier_id': cashierId};
  final STLHttpClient _httpClient;
  Future<NewBetLoaded> _onValidateEvent(AppendBetDTO dto) async {
    final rawState = state.copyWith(items: [
      ...state.items,
      dto.copyWith(
        winAmount: dto.betAmount * dto.winAmount,
      )
    ]);
    try {
      final result = await _httpClient.post(
        '$adminEndpoint/bets/append/${dto.betNumber}',
        queryParams: cashierIdParam,
      );
      if (result != null) {
        if (result is String) {
          return rawState;
        }
        if (result is Map<String, dynamic>) {
          final rawAmount = result['winning_amount'];
          final winAmount = rawAmount is String
              ? double.parse(rawAmount)
              : rawAmount as double;
          return state.copyWith(
            items: [...state.items, dto.copyWith(winAmount: winAmount)],
          );
        }
      }
    } catch (e) {
      addError(e);
      if (e is DioError) {
        final err = e.response?.data['errors']['message'][0];
        return state.copyWith(
          error: err ?? '',
        );
      }
    }
    return rawState;
  }

  void _onInsert(InsertNewBetEvent event, Emitter emit) {
    emit(state.copyWith(
      betAmount: event.betAmount,
      branchId: event.branchId,
      winAmount: event.winAmount,
      drawTypeBet: event.drawTypeBet,
      betNumber: event.betNumber,
      cashier: event.cashier,
    ));
  }

  void _onAppend(AddNewBetEvent event, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    final itemExist = state.items.where(
      (element) => event.dto.betNumber == element.betNumber,
    );
    if (itemExist.isNotEmpty) {
      emit(state.copyWith(error: "Bet Number already exists"));
      return;
    }
    final result = await _onValidateEvent(event.dto);
    emit(result);
  }

  void _onReset(ResetBetEvent event, Emitter emit) {
    emit(state.copyWith(
      items: [],
    ));
  }
}
