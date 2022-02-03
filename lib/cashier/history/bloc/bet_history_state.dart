part of 'bet_history_bloc.dart';

class BetHistoryState extends Equatable {
  final List<BetReceipt> bets;
  final DateTime date;
  final bool isLoading;
  final String error;
  const BetHistoryState({
    this.bets = const [],
    this.isLoading = false,
    this.error = '',
    required this.date,
  });

  bool get hasError => error.isNotEmpty;

  @override
  List<Object> get props => [
        bets,
        error,
        isLoading,
        date,
      ];

  BetHistoryState copyWith({
    List<BetReceipt>? bets,
    DateTime? date,
    bool isLoading = false,
    String error = '',
  }) {
    return BetHistoryState(
      bets: bets ?? this.bets,
      date: date ?? this.date,
      isLoading: isLoading,
      error: error,
    );
  }
}
