part of 'bet_cancel_bloc.dart';

abstract class BetCancelEvent extends Equatable {
  const BetCancelEvent();

  @override
  List<Object?> get props => [];
}

class BetCancelFetchEvent extends BetCancelEvent {
  final String searchItem;
  final bool refresh;
  const BetCancelFetchEvent({
    this.searchItem = '',
    this.refresh = false,
  });

  @override
  List<Object> get props => [searchItem, refresh];
}

class BetCancelByIdEvent extends BetCancelEvent {
  final int id;
  const BetCancelByIdEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
