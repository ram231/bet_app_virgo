part of 'bet_history_bloc.dart';

abstract class BetHistoryEvent extends Equatable {
  const BetHistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchBetHistoryEvent extends BetHistoryEvent {
  FetchBetHistoryEvent({DateTime? dateTime})
      : this.dateTime = dateTime ?? DateTime.now();
  final DateTime dateTime;

  @override
  List<Object> get props => [dateTime];
}
