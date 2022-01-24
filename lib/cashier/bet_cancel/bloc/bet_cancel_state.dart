part of 'bet_cancel_bloc.dart';

enum BetCancelStatus { initial, loading, success, failed }

@immutable
class BetCancelState extends Equatable {
  const BetCancelState({
    this.items = const [],
    this.error,
    this.status = BetCancelStatus.initial,
    this.searchItem = '',
  });
  final List<BetResult> items;
  final Object? error;
  final String searchItem;
  final BetCancelStatus status;
  bool get hasErrors => status == BetCancelStatus.failed && error != null;

  @override
  List<Object> get props => [];
}
