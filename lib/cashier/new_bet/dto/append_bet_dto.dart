import 'dart:convert';

import 'package:bet_app_virgo/models/user_account.dart';
import 'package:equatable/equatable.dart';

import '../../../models/draw.dart';

class AppendBetDTO extends Equatable {
  final String betNumber;
  final double betAmount;
  final DrawBet? drawTypeBet;
  final double winAmount;
  final UserAccount? cashier;
  final bool isLowWin;

  AppendBetDTO({
    required this.betNumber,
    required this.betAmount,
    required this.drawTypeBet,
    required this.winAmount,
    this.cashier,
    this.isLowWin = false,
  });

  AppendBetDTO copyWith({
    String? betNumber,
    double? betAmount,
    DrawBet? drawTypeBet,
    double? winAmount,
    UserAccount? cashier,
    bool? isLowWin,
  }) {
    return AppendBetDTO(
      betNumber: betNumber ?? this.betNumber,
      betAmount: betAmount ?? this.betAmount,
      drawTypeBet: drawTypeBet ?? this.drawTypeBet,
      winAmount: winAmount ?? this.winAmount,
      cashier: cashier ?? this.cashier,
      isLowWin: isLowWin ?? this.isLowWin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'betNumber': betNumber,
      'betAmount': betAmount,
      'drawTypeBet': drawTypeBet?.toMap(),
      'winAmount': winAmount,
    };
  }

  factory AppendBetDTO.fromMap(Map<String, dynamic> map) {
    return AppendBetDTO(
      betNumber: map['betNumber'],
      betAmount: map['betAmount'] ?? 0.0,
      drawTypeBet: DrawBet.fromMap(map['drawTypeBet']),
      winAmount: map['winAmount'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppendBetDTO.fromJson(String source) =>
      AppendBetDTO.fromMap(json.decode(source));

  @override
  List<Object?> get props {
    return [
      betNumber,
      betAmount,
      drawTypeBet,
      winAmount,
      cashier,
      isLowWin,
    ];
  }
}
