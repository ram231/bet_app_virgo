import 'package:bet_app_virgo/cashier/new_bet/dto/append_bet_dto.dart';
import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bet_app_virgo/models/draw.dart';
import 'package:bet_app_virgo/models/user_account.dart';
import 'package:bet_app_virgo/utils/http_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
    emit(CreateNewBetLoading());
    final result = await _httpClient.post('$adminEndpoint/bets', body: {
      'cashier_id': cashier.id,
      'branch_id': cashier.branchId,
      'gambler_id': 1,
      'bet_amount': items.first.betAmount,
      'bet_number': items.map((e) => e.betNumber).toList(),
      'draw_id': drawBet.drawType?.id,
    }, onSerialize: (json) {
      return BetResult.fromMap(json);
    });
    emit(CreateNewBetLoaded(result: result));
  }
}
