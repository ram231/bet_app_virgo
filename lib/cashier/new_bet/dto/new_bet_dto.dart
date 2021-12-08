import 'dart:convert';

import 'package:equatable/equatable.dart';

class NewBetDTO extends Equatable {
  final int? betNumber;
  final double betAmount;
  final int gambleId;
  final int cashierId;
  final int branchId;
  NewBetDTO({
    this.betNumber,
    this.betAmount = 0,
    required this.gambleId,
    required this.cashierId,
    required this.branchId,
  });

  NewBetDTO copyWith({
    int? betNumber,
    double? betAmount,
    int? gambleId,
    int? cashierId,
    int? branchId,
  }) {
    return NewBetDTO(
      betNumber: betNumber ?? this.betNumber,
      betAmount: betAmount ?? this.betAmount,
      gambleId: gambleId ?? this.gambleId,
      cashierId: cashierId ?? this.cashierId,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bet_number': betNumber,
      'bet_amount': betAmount,
      'gamble_id': gambleId,
      'cashier_id': cashierId,
      'branch_id': branchId,
    };
  }

  factory NewBetDTO.fromMap(Map<String, dynamic> map) {
    return NewBetDTO(
      betNumber: map['betNumber'],
      betAmount: map['bet_amount'] ?? 0.0,
      gambleId: map['gamble_id'] ?? 0,
      cashierId: map['cashier_id'] ?? 0,
      branchId: map['branch_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewBetDTO.fromJson(String source) =>
      NewBetDTO.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      betNumber,
      betAmount,
      gambleId,
      cashierId,
      branchId,
    ];
  }
}
