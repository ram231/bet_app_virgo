import 'dart:convert';

import 'package:bet_app_virgo/models/branch.dart';
import 'package:bet_app_virgo/models/user_account.dart';
import 'package:equatable/equatable.dart';

class BetResult extends Equatable {
  final int? id;
  final BetDrawResult? draw;
  final BetBranch? branch;
  final UserAccount? gambler;
  final UserAccount? cashier;
  final String? betAmount;
  final String? readableBetAmount;
  final List<int> betNumber;
  final int? isWinner;
  BetResult({
    required this.id,
    this.draw,
    this.branch,
    this.gambler,
    this.cashier,
    required this.betAmount,
    required this.readableBetAmount,
    required this.betNumber,
    required this.isWinner,
  });

  BetResult copyWith({
    int? id,
    BetDrawResult? draw,
    BetBranch? branch,
    UserAccount? gambler,
    UserAccount? cashier,
    String? betAmount,
    String? readableBetAmount,
    List<int>? betNumber,
    int? isWinner,
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
      isWinner: isWinner ?? this.isWinner,
    );
  }

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
      'isWinner': isWinner,
    };
  }

  factory BetResult.fromMap(Map<String, dynamic> map) {
    return BetResult(
      id: map['id'] != null ? map['id'] : null,
      draw: map['draw'] != null ? BetDrawResult.fromMap(map['draw']) : null,
      branch: map['branch'] != null ? BetBranch.fromMap(map['branch']) : null,
      gambler:
          map['gambler'] != null ? UserAccount.fromMap(map['gambler']) : null,
      cashier:
          map['cashier'] != null ? UserAccount.fromMap(map['cashier']) : null,
      betAmount: map['bet_amount'] != null ? map['bet_amount'] : null,
      readableBetAmount: map['readable_bet_amount'] != null
          ? map['readable_bet_amount']
          : null,
      betNumber: List<int>.from(map['bet_number'] ?? const []),
      isWinner: map['is_winner'] != null ? map['is_winner'] : null,
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
      isWinner,
    ];
  }
}

class BetDrawResult extends Equatable {
  final int? id;
  final int? drawTypeId;
  final int? employeeId;
  final String? drawStart;
  final String? drawEnd;
  final String? winningAmount;
  final List<String> winningNumber;
  BetDrawResult({
    this.id = 1,
    this.drawTypeId,
    this.employeeId,
    this.drawStart,
    this.drawEnd,
    this.winningAmount,
    this.winningNumber = const [],
  });

  BetDrawResult copyWith({
    int? id,
    int? drawTypeId,
    int? employeeId,
    String? drawStart,
    String? drawEnd,
    String? winningAmount,
    List<String>? winningNumber,
  }) {
    return BetDrawResult(
      id: id ?? this.id,
      drawTypeId: drawTypeId ?? this.drawTypeId,
      employeeId: employeeId ?? this.employeeId,
      drawStart: drawStart ?? this.drawStart,
      drawEnd: drawEnd ?? this.drawEnd,
      winningAmount: winningAmount ?? this.winningAmount,
      winningNumber: winningNumber ?? this.winningNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'draw_type_id': drawTypeId,
      'employee_id': employeeId,
      'draw_start': drawStart,
      'draw_end': drawEnd,
      'winning_amount': winningAmount,
      'winning_number': winningNumber,
    };
  }

  factory BetDrawResult.fromMap(Map<String, dynamic> map) {
    return BetDrawResult(
      id: map['id'] != null ? map['id'] : null,
      drawTypeId: map['draw_type_id'] != null ? map['draw_type_id'] : null,
      employeeId: map['employee_id'] != null ? map['employee_id'] : null,
      drawStart: map['draw_start'] != null ? map['draw_start'] : null,
      drawEnd: map['draw_end'] != null ? map['draw_end'] : null,
      winningAmount:
          map['winning_amount'] != null ? map['winning_amount'] : null,
      winningNumber: List<String>.from(map['winning_number'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory BetDrawResult.fromJson(String source) =>
      BetDrawResult.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      drawTypeId,
      employeeId,
      drawStart,
      drawEnd,
      winningAmount,
      winningNumber,
    ];
  }
}
