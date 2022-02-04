import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'models.dart';

class BetResult extends Equatable {
  final int? id;
  final DrawBet? draw;
  final BetBranch? branch;
  final UserAccount? gambler;
  final UserAccount? cashier;
  final num? betAmount;
  final String? readableBetAmount;
  final int? betNumber;
  final int? prize;
  final bool isCancel;
  final bool isWinner;
  final String? readablePrize;
  final String? winningAmount;
  final String? readableWinningAmount;
  final BetReceipt? receipt;
  BetResult({
    required this.id,
    this.draw,
    this.branch,
    this.gambler,
    this.cashier,
    required this.betAmount,
    required this.readableBetAmount,
    required this.betNumber,
    this.prize = 0,
    this.isCancel = false,
    this.isWinner = false,
    this.readablePrize,
    this.winningAmount,
    this.readableWinningAmount,
    this.receipt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'draw': draw?.toMap(),
      'branch': branch?.toMap(),
      'gambler': gambler?.toMap(),
      'cashier': cashier?.toMap(),
      'betAmount': betAmount,
      'readableBetAmount': readableBetAmount,
      'betNumber': betNumber,
      'prize': prize,
      'is_winner': isWinner ? 1 : 0,
      'is_cancel': isCancel,
      'receipt': receipt?.toMap(),
    };
  }

  factory BetResult.fromMap(Map<String, dynamic> map) {
    return BetResult(
      id: map['id'] != null ? map['id'] : null,
      draw: map['draw'] != null ? DrawBet.fromMap(map['draw']) : null,
      branch: map['branch'] != null ? BetBranch.fromMap(map['branch']) : null,
      receipt:
          map['receipt'] != null ? BetReceipt.fromMap(map['receipt']) : null,
      gambler:
          map['gambler'] != null ? UserAccount.fromMap(map['gambler']) : null,
      cashier:
          map['cashier'] != null ? UserAccount.fromMap(map['cashier']) : null,
      betAmount: map['bet_amount'] != null
          ? map['bet_amount'] is String
              ? double.parse(map['bet_amount'])
              : map['bet_amount']
          : null,
      readableBetAmount: map['readable_bet_amount'] != null
          ? map['readable_bet_amount']
          : null,
      betNumber: map['bet_number'],
      prize: map['prize'] is String
          ? double.parse(map['prize']).toInt()
          : map['prize'],
      isCancel:
          map['is_cancel'] is bool ? map['is_cancel'] : map['is_cancel'] == 1,
      isWinner:
          map['is_winner'] is bool ? map['is_winner'] : map['is_cancel'] == 1,
      readablePrize: map['readable_prize'],
      winningAmount: map['winning_amount'],
      readableWinningAmount: map['readable_winning_amount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BetResult.fromJson(String source) =>
      BetResult.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      draw,
      branch,
      gambler,
      cashier,
      betAmount,
      readableBetAmount,
      betNumber,
      prize,
      isWinner,
      isCancel,
      receipt,
    ];
  }

  BetResult copyWith({
    int? id,
    DrawBet? draw,
    BetBranch? branch,
    UserAccount? gambler,
    UserAccount? cashier,
    num? betAmount,
    String? readableBetAmount,
    int? betNumber,
    int? prize,
    bool? isCancel,
    bool? isWinner,
    String? readablePrize,
    String? winningAmount,
    String? readableWinningAmount,
    BetReceipt? receipt,
  }) {
    return BetResult(
      id: id ?? this.id,
      draw: draw ?? this.draw,
      branch: branch ?? this.branch,
      gambler: gambler ?? this.gambler,
      cashier: cashier ?? this.cashier,
      betAmount: betAmount ?? this.betAmount,
      readableBetAmount: readableBetAmount ?? this.readableBetAmount,
      betNumber: betNumber ?? this.betNumber,
      prize: prize ?? this.prize,
      isCancel: isCancel ?? this.isCancel,
      isWinner: isWinner ?? this.isWinner,
      readablePrize: readablePrize ?? this.readablePrize,
      winningAmount: winningAmount ?? this.winningAmount,
      readableWinningAmount:
          readableWinningAmount ?? this.readableWinningAmount,
      receipt: receipt ?? this.receipt,
    );
  }
}
