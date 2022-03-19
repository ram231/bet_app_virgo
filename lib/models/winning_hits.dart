import 'dart:convert';

import 'package:bet_app_virgo/models/draw.dart';
import 'package:equatable/equatable.dart';

class WinningHitsResult extends Equatable {
  final int? id;
  final DrawBet? draw;
  final int? totalWinners;
  final int? totalBetAmount;
  final String? readableTotalBetAmount;
  final int? winningAmount;
  final String? readableWinningAmount;
  final int? prize;
  final String? readablePrize;
  final int? tapalKabig;
  final String? readableTapalKabig;
  final String? createdAt;
  final String? updatedAt;
  final String? readableCreatedAt;
  final String? readableUpdatedAt;
  const WinningHitsResult({
    this.id,
    this.draw,
    this.totalWinners,
    this.totalBetAmount,
    this.readableTotalBetAmount,
    this.winningAmount,
    this.readableWinningAmount,
    this.prize,
    this.readablePrize,
    this.createdAt,
    this.updatedAt,
    this.readableCreatedAt,
    this.readableUpdatedAt,
    this.tapalKabig,
    this.readableTapalKabig,
  });

  WinningHitsResult copyWith({
    int? id,
    DrawBet? draw,
    int? totalWinners,
    int? totalBetAmount,
    String? readableTotalBetAmount,
    int? winningAmount,
    String? readableWinningAmount,
    int? prize,
    String? readablePrize,
    int? tapalKabig,
    String? readableTapalKabig,
    String? createdAt,
    String? updatedAt,
    String? readableCreatedAt,
    String? readableUpdatedAt,
  }) {
    return WinningHitsResult(
      id: id ?? this.id,
      draw: draw ?? this.draw,
      totalWinners: totalWinners ?? this.totalWinners,
      totalBetAmount: totalBetAmount ?? this.totalBetAmount,
      readableTotalBetAmount:
          readableTotalBetAmount ?? this.readableTotalBetAmount,
      winningAmount: winningAmount ?? this.winningAmount,
      readableWinningAmount:
          readableWinningAmount ?? this.readableWinningAmount,
      prize: prize ?? this.prize,
      readablePrize: readablePrize ?? this.readablePrize,
      tapalKabig: tapalKabig ?? this.tapalKabig,
      readableTapalKabig: readableTapalKabig ?? this.readableTapalKabig,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      readableCreatedAt: readableCreatedAt ?? this.readableCreatedAt,
      readableUpdatedAt: readableUpdatedAt ?? this.readableUpdatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'draw': draw?.toMap(),
      'total_winners': totalWinners,
      'total_bet_amount': totalBetAmount,
      'readable_total_bet_amount': readableTotalBetAmount,
      'winning_amount': winningAmount,
      'readable_winning_amount': readableWinningAmount,
      'prize': prize,
      'readable_prize': readablePrize,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'readable_created_at': readableCreatedAt,
      'readable_updated_at': readableUpdatedAt,
    };
  }

  factory WinningHitsResult.fromMap(Map<String, dynamic> map) {
    return WinningHitsResult(
      id: map['id'],
      draw: DrawBet.fromMap(map['draw']),
      totalWinners: map['total_winners'],
      totalBetAmount: map['total_bet_amount'] is String
          ? num.parse(map['total_bet_amount']).toInt()
          : map['total_bet_amount'],
      readableTotalBetAmount: map['readable_total_bet_amount'],
      winningAmount: map['winning_amount'] is String
          ? num.parse(map['winning_amount']).toInt()
          : map['winning_amount'],
      readableWinningAmount: map['readable_winning_amount'],
      prize: map['prize'] is String
          ? num.parse(map['prize']).toInt()
          : map['prize'],
      readablePrize: map['readable_prize'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      readableCreatedAt: map['readable_created_at'],
      readableUpdatedAt: map['readable_updated_at'],
      tapalKabig: map['tapal_kabig'] is String
          ? num.parse(map['tapal_kabig']).toInt()
          : map['tapal_kabig'],
      readableTapalKabig: map['readable_tapal_kabig'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WinningHitsResult.fromJson(String source) =>
      WinningHitsResult.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      draw,
      totalWinners,
      totalBetAmount,
      readableTotalBetAmount,
      winningAmount,
      readableWinningAmount,
      prize,
      readablePrize,
      createdAt,
      updatedAt,
      readableCreatedAt,
      readableUpdatedAt,
    ];
  }
}
