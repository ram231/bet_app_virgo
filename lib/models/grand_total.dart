import 'dart:convert';

import 'package:equatable/equatable.dart';

/// this model is only usable by the admin. not usable for cashiers
class AdminGrandTotal extends Equatable {
  final int userId;
  final String createdBy;
  final int betAmount;
  final String readableBetAmount;
  final int hits;
  final String readableHits;
  AdminGrandTotal({
    required this.userId,
    required this.createdBy,
    required this.betAmount,
    required this.readableBetAmount,
    required this.hits,
    required this.readableHits,
  });

  AdminGrandTotal copyWith({
    int? userId,
    String? createdBy,
    int? betAmount,
    String? readableBetAmount,
    int? hits,
    String? readableHits,
  }) {
    return AdminGrandTotal(
      userId: userId ?? this.userId,
      createdBy: createdBy ?? this.createdBy,
      betAmount: betAmount ?? this.betAmount,
      readableBetAmount: readableBetAmount ?? this.readableBetAmount,
      hits: hits ?? this.hits,
      readableHits: readableHits ?? this.readableHits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'createdBy': createdBy,
      'betAmount': betAmount,
      'readableBetAmount': readableBetAmount,
      'hits': hits,
      'readableHits': readableHits,
    };
  }

  factory AdminGrandTotal.fromMap(Map<String, dynamic> map) {
    return AdminGrandTotal(
      userId: map['user_id']?.toInt() ?? 0,
      createdBy: map['created_by'] ?? '',
      betAmount: map['bet_amount'] is String
          ? int.parse(map['bet_amount'].split(".").first)
          : map['bet_amount']?.toInt() ?? 0,
      readableBetAmount: map['readable_bet_amount'] ?? '',
      hits: map['hits'] is String
          ? int.parse(map['hits'].split(".").first)
          : map['hits']?.toInt() ?? 0,
      readableHits: map['readable_hits'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminGrandTotal.fromJson(String source) =>
      AdminGrandTotal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AdminGrandTotal(userId: $userId, createdBy: $createdBy, betAmount: $betAmount, readableBetAmount: $readableBetAmount, hits: $hits, readableHits: $readableHits)';
  }

  @override
  List<Object> get props {
    return [
      userId,
      createdBy,
      betAmount,
      readableBetAmount,
      hits,
      readableHits,
    ];
  }
}
