import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_new_bet_state.dart';

class CreateNewBetCubit extends Cubit<List<BetResult>> {
  CreateNewBetCubit({
    List<BetResult> betResult = const [],
  }) : super(betResult);
}
