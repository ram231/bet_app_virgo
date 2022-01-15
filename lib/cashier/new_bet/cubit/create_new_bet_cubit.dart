import 'package:bet_app_virgo/cashier/new_bet/dto/append_bet_dto.dart';
import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bet_app_virgo/models/draw.dart';
import 'package:bet_app_virgo/models/user_account.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'create_new_bet_state.dart';

class CreateNewBetCubit extends Cubit<CreateNewBetState> {
  CreateNewBetCubit({STLHttpClient? httpClient})
      : _httpClient = httpClient ?? STLHttpClient(),
        super(CreateNewBetInitial());
  final STLHttpClient _httpClient;
  void onSave(
    UserAccount cashier,
    List<AppendBetDTO> items,
    DrawBet drawBet,
  ) async {
    try {
      emit(CreateNewBetLoading());
      final request = items.map((e) {
        final data = {
          'cashier_id': cashier.id,
          'branch_id': drawBet.employee?.branchId ?? cashier.branchId,
          'bet_amount': e.betAmount,
          'bet_number': e.betNumber,
          'draw_id': drawBet.id,
          'prize': e.winAmount,
        };
        return _httpClient.post(
          '$adminEndpoint/bets',
          body: data,
          onSerialize: (json) => BetResult.fromMap(json),
        );
      }).toList();
      final result = await Future.wait(request);

      emit(CreateNewBetLoaded(result: result));
    } catch (e) {
      if (e is DioError) {
        emit(CreateNewBetError(error: e.response?.data['message']));
      }
      addError(e);
      debugPrint("$e");
    }
  }
}
