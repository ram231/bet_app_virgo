part of 'new_bet_bloc.dart';

abstract class NewBetEvent extends Equatable {
  const NewBetEvent();

  @override
  List<Object?> get props => [];
}

class AddNewBetEvent extends NewBetEvent {
  final AppendBetDTO dto;
  AddNewBetEvent({
    required this.dto,
  });
  @override
  List<Object?> get props => [dto];
}

class InsertNewBetEvent extends NewBetEvent {
  final int? betNumber;
  final double? betAmount;
  final DrawBet? drawTypeBet;
  final int? branchId;
  final double? winAmount;
  final UserAccount? cashier;
  InsertNewBetEvent({
    this.betNumber,
    this.betAmount,
    this.drawTypeBet,
    this.branchId,
    this.winAmount,
    this.cashier,
  });

  InsertNewBetEvent copyWith({
    int? betNumber,
    double? betAmount,
    DrawBet? drawTypeBet,
    int? branchId,
    double? winAmount,
    UserAccount? cashier,
  }) {
    return InsertNewBetEvent(
      betNumber: betNumber ?? this.betNumber,
      betAmount: betAmount ?? this.betAmount,
      drawTypeBet: drawTypeBet ?? this.drawTypeBet,
      branchId: branchId ?? this.branchId,
      winAmount: winAmount ?? this.winAmount,
      cashier: cashier ?? this.cashier,
    );
  }
}

class SaveBetEvent extends NewBetEvent {}

class ResetBetEvent extends NewBetEvent {}

class ValidateBetNumberEvent extends NewBetEvent {
  final String betNumber;
  final DrawBet draw;
  ValidateBetNumberEvent({
    required this.betNumber,
    required this.draw,
  });
}

class SubmitBetEvent extends NewBetEvent {}

class ConnectPrinterEvent extends NewBetEvent {
  final bool isConnected;
  ConnectPrinterEvent({this.isConnected = false});

  @override
  // TODO: implement props
  List<Object?> get props => [isConnected];
}
