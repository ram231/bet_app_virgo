part of 'bet_history_bloc.dart';

class BetHistoryState extends Equatable {
  final List<BetReceipt> bets;
  final DateTime date;
  final bool isLoading;
  final String error;
  final List<BetReceipt> searchResult;
  final bool isPrinting;
  const BetHistoryState({
    this.bets = const [],
    required this.date,
    this.isLoading = false,
    this.error = '',
    this.searchResult = const [],
    this.isPrinting = false,
  });

  bool get hasError => error.isNotEmpty;
  List<BetReceipt> get receipts {
    if (searchResult.isEmpty) {
      return bets;
    }
    return searchResult;
  }

  @override
  List<Object> get props {
    return [
      bets,
      date,
      isLoading,
      error,
      searchResult,
    ];
  }

  BetHistoryState copyWith({
    List<BetReceipt>? bets,
    DateTime? date,
    bool? isLoading,
    String error = "",
    List<BetReceipt> searchResult = const [],
    bool isPrinting = false,
  }) {
    return BetHistoryState(
      bets: bets ?? this.bets,
      date: date ?? this.date,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchResult: searchResult,
      isPrinting: isPrinting,
    );
  }
}
