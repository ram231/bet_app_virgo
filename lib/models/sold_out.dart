import 'dart:convert';

import 'package:equatable/equatable.dart';

class BetSoldOut extends Equatable {
  final int id;
  final String? soldOutNumber;
  final String? twoDigitWinningAmount;
  final String? threeDigitWinningAmount;
  final String? readableWinAmount;
  final String? readableThreeDigitWinningAmount;
  BetSoldOut({
    required this.id,
    required this.soldOutNumber,
    this.twoDigitWinningAmount = '',
    this.readableWinAmount = '',
    this.threeDigitWinningAmount = '',
    this.readableThreeDigitWinningAmount,
  });

  BetSoldOut copyWith({
    int? id,
    String? soldOutNumber,
    String? winAmount,
    String? readableWinAmount,
  }) {
    return BetSoldOut(
      id: id ?? this.id,
      soldOutNumber: soldOutNumber ?? this.soldOutNumber,
      twoDigitWinningAmount: winAmount ?? this.twoDigitWinningAmount,
      readableWinAmount: readableWinAmount ?? this.readableWinAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sold_out_number': soldOutNumber,
    };
  }

  factory BetSoldOut.fromMap(Map<String, dynamic> map) {
    final lowWin = map['low_win_number'] ?? map['sold_out_number'];
    final winChecker = map['two_digits_winning_amount'].toString();
    return BetSoldOut(
        id: map['id']?.toInt() ?? 0,
        soldOutNumber: lowWin,
        twoDigitWinningAmount: winChecker,
        readableWinAmount: map['readable_two_digits_winning_amount'] ?? '',
        threeDigitWinningAmount: map['three_digits_winning_amount'],
        readableThreeDigitWinningAmount:
            map['readable_three_digits_winning_amount']);
  }
  String toJson() => json.encode(toMap());

  factory BetSoldOut.fromJson(String source) =>
      BetSoldOut.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        id,
        soldOutNumber,
        twoDigitWinningAmount,
        readableWinAmount,
        threeDigitWinningAmount,
        readableThreeDigitWinningAmount
      ];
}
