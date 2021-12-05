part of 'bet_history_bloc.dart';

abstract class BetHistoryEvent extends Equatable {
  const BetHistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchBetHistoryEvent extends BetHistoryEvent {}
