part of 'new_bet_bloc.dart';

enum PrintStatus {
  printing,
  idle,
  done,
}

class NewBetLoaded extends Equatable {
  final List<AppendBetDTO> items;
  final List<BetResult> result;
  final int? betNumber;
  final double? betAmount;
  final DrawBet? drawTypeBet;
  final double? winAmount;
  final UserAccount? cashier;
  final String error;
  final bool isLoading;
  final bool isConnected;
  final PrintStatus status;
  const NewBetLoaded({
    this.items = const [],
    this.result = const [],
    this.betNumber,
    this.betAmount,
    this.drawTypeBet,
    this.winAmount,
    this.cashier,
    this.error = '',
    this.isLoading = false,
    this.isConnected = false,
    this.status = PrintStatus.idle,
  });

  bool get canSave =>
      status == PrintStatus.idle &&
      !isLoading &&
      isConnected &&
      items.isNotEmpty;

  NewBetLoaded copyWith({
    List<AppendBetDTO>? items,
    int? betNumber,
    double? betAmount,
    DrawBet? drawTypeBet,
    int? branchId,
    double? winAmount,
    UserAccount? cashier,
    String error = '',
    bool isLoading = false,
    bool? isConnected,
    List<BetResult>? result,
    PrintStatus status = PrintStatus.idle,
  }) {
    return NewBetLoaded(
      items: items ?? this.items,
      betNumber: betNumber ?? this.betNumber,
      betAmount: betAmount ?? this.betAmount,
      drawTypeBet: drawTypeBet ?? this.drawTypeBet,
      winAmount: winAmount ?? this.winAmount,
      cashier: cashier ?? this.cashier,
      error: error,
      isLoading: isLoading,
      isConnected: isConnected ?? this.isConnected,
      result: result ?? this.result,
      status: status,
    );
  }

  @override
  List<Object?> get props => [
        items,
        betNumber,
        betAmount,
        drawTypeBet,
        winAmount,
        error,
        isLoading,
        isConnected,
        result,
        status,
      ];
}
