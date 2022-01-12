import 'dart:convert';

import 'package:bet_app_virgo/models/user_account.dart';
import 'package:equatable/equatable.dart';

class DrawBet extends Equatable {
  final int id;
  final DrawTypeBet? drawType;
  final UserAccount? employee;
  final String? drawStart;
  final String? drawEnd;
  final String winningAmount;
  final String readableWinningAmount;
  final int? winningCombination;
  final String status;
  final int prize;
  final String? timeStart;
  final String? timeEnd;
  const DrawBet({
    required this.id,
    this.drawType,
    this.employee,
    this.drawStart,
    this.drawEnd,
    this.winningAmount = '',
    this.readableWinningAmount = '',
    this.winningCombination,
    this.status = 'C',
    this.prize = 0,
    this.timeStart,
    this.timeEnd,
  });

  DrawBet copyWith({
    int? id,
    DrawTypeBet? drawType,
    UserAccount? employee,
    String? drawStart,
    String? drawEnd,
    String? winningAmount,
    String? readableWinningAmount,
    int? winningNumber,
    String? status,
  }) {
    return DrawBet(
      id: id ?? this.id,
      drawType: drawType ?? this.drawType,
      employee: employee ?? this.employee,
      drawStart: drawStart ?? this.drawStart,
      drawEnd: drawEnd ?? this.drawEnd,
      winningAmount: winningAmount ?? this.winningAmount,
      readableWinningAmount:
          readableWinningAmount ?? this.readableWinningAmount,
      winningCombination: winningNumber ?? this.winningCombination,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'draw_type': drawType?.toMap(),
      'employee': employee?.toMap(),
      'draw_start': drawStart,
      'draw_end': drawEnd,
      'winning_amount': winningAmount,
      'readable_winning_amount': readableWinningAmount,
      'winning_combination': winningCombination,
      'status': status,
      'prize': prize,
      'time_start': timeStart,
      'time_end': timeEnd,
    };
  }

  factory DrawBet.fromMap(Map<String, dynamic> map) {
    return DrawBet(
      id: map['id'] ?? 0,
      drawType: map['draw_type'] != null
          ? DrawTypeBet.fromMap(map['draw_type'])
          : null,
      employee:
          map['employee'] != null ? UserAccount.fromMap(map['employee']) : null,
      drawStart: map['draw_start'],
      drawEnd: map['draw_end'],
      winningAmount: map['winning_amount'] ?? '',
      readableWinningAmount: map['readable_winning_amount'] ?? '',
      winningCombination: map['winning_combination'],
      status: map['status'] ?? 'C',
      prize: map['prize'] != null ? int.parse(map['prize']) : 0,
      timeStart: map['time_start'],
      timeEnd: map['time_end'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DrawBet.fromJson(String source) =>
      DrawBet.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      drawType,
      employee,
      drawStart,
      drawEnd,
      winningAmount,
      readableWinningAmount,
      winningCombination,
      status,
      prize,
      timeStart,
      timeEnd,
    ];
  }
}

class DrawTypeBet extends Equatable {
  final int id;
  final String name;
  final num digits;
  DrawTypeBet({
    required this.id,
    required this.name,
    required this.digits,
  });

  DrawTypeBet copyWith({
    int? id,
    String? name,
    num? digits,
  }) {
    return DrawTypeBet(
      id: id ?? this.id,
      name: name ?? this.name,
      digits: digits ?? this.digits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'digits': digits,
    };
  }

  factory DrawTypeBet.fromMap(Map<String, dynamic> map) {
    return DrawTypeBet(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      digits: map['digits'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DrawTypeBet.fromJson(String source) =>
      DrawTypeBet.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, digits];
}
