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
  final List<String> winningNumber;

  const DrawBet({
    required this.id,
    this.drawType,
    this.employee,
    this.drawStart,
    this.drawEnd,
    this.winningAmount = '',
    this.readableWinningAmount = '',
    this.winningNumber = const [],
  });

  DrawBet copyWith({
    int? id,
    DrawTypeBet? drawType,
    UserAccount? employee,
    String? drawStart,
    String? drawEnd,
    String? winningAmount,
    String? readableWinningAmount,
    List<String>? winningNumber,
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
      winningNumber: winningNumber ?? this.winningNumber,
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
      'winning_number': winningNumber,
    };
  }

  factory DrawBet.fromMap(Map<String, dynamic> map) {
    return DrawBet(
      id: map['id'] ?? 0,
      drawType: map['draw_type'] != null
          ? DrawTypeBet.fromMap(map['draw_type'])
          : null,
      // employee:
      //     map['employee'] != null ? UserAccount.fromMap(map['employee']) : null,
      drawStart: map['draw_start'],
      drawEnd: map['draw_end'],
      winningAmount: map['winning_amount'] ?? '',
      readableWinningAmount: map['readable_winning_amount'] ?? '',
      winningNumber: List<String>.from(map['winning_number'] ?? const []),
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
      winningNumber,
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
