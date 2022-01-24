part of 'bet_history_bloc.dart';

abstract class BetHistoryState extends Equatable {
  const BetHistoryState();

  @override
  List<Object> get props => [];
}

class BetHistoryInitial extends BetHistoryState {}

class BetHistoryLoading extends BetHistoryState {}

class BetHistoryLoaded extends BetHistoryState {
  final List<BetResult> bets;
  const BetHistoryLoaded(this.bets);
  @override
  List<Object> get props => [bets];
}

class BetHistoryError extends BetHistoryState {
  final Object error;
  BetHistoryError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
