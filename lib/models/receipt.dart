import 'dart:convert';

import 'package:bet_app_virgo/models/user_account.dart';
import 'package:equatable/equatable.dart';

class BetReceipt extends Equatable {
  final int? id;
  final UserAccount? user;
  final String? receiptNo;
  final String? status;
  final String? readableStatus;
  final List<BetReceiptObject> bets;
  final String? createdAt;
  final String? createdAtText;
  final int? prizesClaimed;
  final String? readablePrizesClaimed;
  const BetReceipt({
    this.id,
    this.user,
    this.receiptNo,
    this.status,
    this.readableStatus,
    this.bets = const [],
    this.createdAt,
    this.createdAtText,
    this.prizesClaimed,
    this.readablePrizesClaimed,
  });

  BetReceipt copyWith({
    int? id,
    UserAccount? cashier,
    String? receiptNo,
    String? status,
    String? readableStatus,
    List<BetReceiptObject>? bets,
    String? createdAt,
    String? createdAtText,
    int? prizesClaimed,
    String? readablePrizesClaimed,
  }) {
    return BetReceipt(
      id: id ?? this.id,
      user: cashier ?? this.user,
      receiptNo: receiptNo ?? this.receiptNo,
      status: status ?? this.status,
      readableStatus: readableStatus ?? this.readableStatus,
      bets: bets ?? this.bets,
      createdAt: createdAt ?? this.createdAt,
      createdAtText: createdAtText ?? this.createdAtText,
      prizesClaimed: prizesClaimed ?? this.prizesClaimed,
      readablePrizesClaimed:
          readablePrizesClaimed ?? this.readablePrizesClaimed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cashier': user?.toMap(),
      'receipt_o': receiptNo,
      'status': status,
      'readable_status': readableStatus,
      'bets': bets.map((x) => x.toMap()).toList(),
      'created_at': createdAt,
      'created_at_text': createdAtText,
      'readable_prizes_claimed': readablePrizesClaimed,
      'prizes_claimed': prizesClaimed,
    };
  }

  factory BetReceipt.fromMap(Map<String, dynamic> map) {
    return BetReceipt(
      id: map['id']?.toInt(),
      user: map['user'] != null ? UserAccount.fromMap(map['user']) : null,
      receiptNo: map['receipt_no'] is int
          ? map['receipt_no'].toString()
          : map['receipt_no'],
      status: map['status'],
      readableStatus: map['readable_status'],
      bets: List<BetReceiptObject>.from(
          map['bets']?.map((x) => BetReceiptObject.fromMap(x)) ?? const []),
      createdAt: map['created_at'],
      createdAtText: map['created_at_text'],
      readablePrizesClaimed: map['readable_prizes_claimed'],
      prizesClaimed: map['prizes_claimed'] is String?
          ? double.parse(map['prizes_claimed']).toInt()
          : map['prizes_claimed'],
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
      user,
      receiptNo,
      status,
      readableStatus,
      bets,
      createdAt,
      createdAtText,
      prizesClaimed,
      readablePrizesClaimed,
    ];
  }
}

class BetReceiptObject extends Equatable {
  final int id;
  final int drawId;
  final int branchId;
  final int receiptId;
  final int betNumber;
  final String betAmount;
  final String winningAmount;
  final String prize;
  final int isWinner;
  final int isCancel;
  final String createdAt;
  final String updatedAt;
  BetReceiptObject({
    required this.id,
    required this.drawId,
    required this.branchId,
    required this.receiptId,
    required this.betNumber,
    required this.betAmount,
    required this.winningAmount,
    required this.prize,
    required this.isWinner,
    required this.isCancel,
    required this.createdAt,
    required this.updatedAt,
  });

  BetReceiptObject copyWith({
    int? id,
    int? drawId,
    int? branchId,
    int? receiptId,
    int? betNumber,
    String? betAmount,
    String? winningAmount,
    String? prize,
    int? isWinner,
    int? isCancel,
    String? createdAt,
    String? updatedAt,
  }) {
    return BetReceiptObject(
      id: id ?? this.id,
      drawId: drawId ?? this.drawId,
      branchId: branchId ?? this.branchId,
      receiptId: receiptId ?? this.receiptId,
      betNumber: betNumber ?? this.betNumber,
      betAmount: betAmount ?? this.betAmount,
      winningAmount: winningAmount ?? this.winningAmount,
      prize: prize ?? this.prize,
      isWinner: isWinner ?? this.isWinner,
      isCancel: isCancel ?? this.isCancel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'draw_id': drawId,
      'branch_id': branchId,
      'receipt_id': receiptId,
      'bet_number': betNumber,
      'bet_amount': betAmount,
      'winning_amount': winningAmount,
      'prize': prize,
      'is_winner': isWinner,
      'is_cancel': isCancel,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory BetReceiptObject.fromMap(Map<String, dynamic> map) {
    return BetReceiptObject(
      id: map['id']?.toInt() ?? 0,
      drawId: map['draw_id']?.toInt() ?? 0,
      branchId: map['branch_id']?.toInt() ?? 0,
      receiptId: map['receipt_id']?.toInt() ?? 0,
      betNumber: map['bet_number']?.toInt() ?? 0,
      betAmount: map['bet_amount'] ?? '',
      winningAmount: map['winning_amount'] ?? '',
      prize: map['prize'] ?? '',
      isWinner: map['is_winner']?.toInt() ?? 0,
      isCancel: map['is_cancel']?.toInt() ?? 0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BetReceiptObject.fromJson(String source) =>
      BetReceiptObject.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BetReceiptObject(id: $id, drawId: $drawId, branchId: $branchId, receiptId: $receiptId, betNumber: $betNumber, betAmount: $betAmount, winningAmount: $winningAmount, prize: $prize, isWinner: $isWinner, isCancel: $isCancel, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  List<Object> get props {
    return [
      id,
      drawId,
      branchId,
      receiptId,
      betNumber,
      betAmount,
      winningAmount,
      prize,
      isWinner,
      isCancel,
      createdAt,
      updatedAt,
    ];
  }
}
