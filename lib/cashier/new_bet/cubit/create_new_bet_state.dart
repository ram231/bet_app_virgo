part of 'create_new_bet_cubit.dart';

abstract class CreateNewBetState extends Equatable {
  const CreateNewBetState();

  @override
  List<Object> get props => [];
}

class CreateNewBetInitial extends CreateNewBetState {}

class CreateNewBetLoading extends CreateNewBetState {}

class CreateNewBetLoaded extends CreateNewBetState {
  final BetResult result;
  CreateNewBetLoaded({
    required this.result,
  });

  @override
  List<Object> get props => [result];
}