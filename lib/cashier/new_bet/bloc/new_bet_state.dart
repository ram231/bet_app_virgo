part of 'new_bet_bloc.dart';

abstract class NewBetState extends Equatable {
  const NewBetState();

  @override
  List<Object?> get props => [];
}

class NewBetInitial extends NewBetState {}

class NewBetLoading extends NewBetState {}

class NewBetLoaded extends NewBetState {
  final List<AppendBetDTO> items;
  final int? betNumber;
  final double? betAmount;
  final DrawBet? drawTypeBet;
  final double? winAmount;
  final UserAccount? cashier;
  NewBetLoaded(
      {this.items = const [],
      this.betNumber,
      this.betAmount,
      this.drawTypeBet,
      this.winAmount,
      this.cashier});

  NewBetLoaded copyWith({
    List<AppendBetDTO>? items,
    int? betNumber,
    double? betAmount,
    DrawBet? drawTypeBet,
    int? branchId,
    double? winAmount,
    UserAccount? cashier,
  }) {
    return NewBetLoaded(
      items: items ?? this.items,
      betNumber: betNumber ?? this.betNumber,
      betAmount: betAmount ?? this.betAmount,
      drawTypeBet: drawTypeBet ?? this.drawTypeBet,
      winAmount: winAmount ?? this.winAmount,
      cashier: cashier ?? this.cashier,
    );
  }

  @override
  List<Object?> get props => [
        items,
        betNumber,
        betAmount,
        drawTypeBet,
        winAmount,
      ];
}
