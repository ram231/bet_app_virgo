import 'dart:convert';

import 'package:bet_app_virgo/models/bet_result.dart';
import 'package:bet_app_virgo/models/user_account.dart';
import 'package:equatable/equatable.dart';

class BetReceipt extends Equatable {
  final int? id;
  final UserAccount? cashier;
  final String? receiptNo;
  final String? status;
  final String? readableStatus;
  final List<BetResult?> bets;
  final String? createdAt;
  final String? createdAtText;
  const BetReceipt({
    this.id,
    this.cashier,
    this.receiptNo,
    this.status,
    this.readableStatus,
    this.bets = const [],
    this.createdAt,
    this.createdAtText,
  });

  BetReceipt copyWith({
    int? id,
    UserAccount? cashier,
    String? receiptNo,
    String? status,
    String? readableStatus,
    List<BetResult?>? bets,
    String? createdAt,
    String? createdAtText,
  }) {
    return BetReceipt(
      id: id ?? this.id,
      cashier: cashier ?? this.cashier,
      receiptNo: receiptNo ?? this.receiptNo,
      status: status ?? this.status,
      readableStatus: readableStatus ?? this.readableStatus,
      bets: bets ?? this.bets,
      createdAt: createdAt ?? this.createdAt,
      createdAtText: createdAtText ?? this.createdAtText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cashier': cashier?.toMap(),
      'receipt_o': receiptNo,
      'status': status,
      'readable_status': readableStatus,
      'bets': bets.map((x) => x?.toMap()).toList(),
      'created_at': createdAt,
      'created_at_text': createdAtText,
    };
  }

  factory BetReceipt.fromMap(Map<String, dynamic> map) {
    return BetReceipt(
      id: map['id']?.toInt(),
      cashier:
          map['cashier'] != null ? UserAccount.fromMap(map['cashier']) : null,
      receiptNo: map['receipt_no'],
      status: map['status'],
      readableStatus: map['readable_status'],
      bets: List<BetResult?>.from(
          map['bets']?.map((x) => BetResult.fromMap(x)) ?? const []),
      createdAt: map['created_at'],
      createdAtText: map['created_at_text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BetReceipt.fromJson(String source) =>
      BetReceipt.fromMap(json.decode(source));

  @override
  bool? get stringify => true;
  @override
  List<Object?> get props {
    return [
      id,
      cashier,
      receiptNo,
      status,
      readableStatus,
      bets,
      createdAt,
      createdAtText,
    ];
  }
}
