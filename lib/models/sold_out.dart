import 'dart:convert';

import 'package:equatable/equatable.dart';

class BetSoldOut extends Equatable {
  final int id;
  final int soldOutNumber;
  final String winAmount;
  final String readableWinAmount;
  BetSoldOut({
    required this.id,
    required this.soldOutNumber,
    this.winAmount = '',
    this.readableWinAmount = '',
  });

  BetSoldOut copyWith({
    int? id,
    int? soldOutNumber,
    String? winAmount,
    String? readableWinAmount,
  }) {
    return BetSoldOut(
      id: id ?? this.id,
      soldOutNumber: soldOutNumber ?? this.soldOutNumber,
      winAmount: winAmount ?? this.winAmount,
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
    final checker =
        lowWin is String ? int.parse(lowWin.split(".").first) : lowWin;
    final winChecker = map['winning_amount'] is String
        ? map['winning_amount']
        : "${map['winning_amount']}";
    return BetSoldOut(
      id: map['id']?.toInt() ?? 0,
      soldOutNumber: (checker)?.toInt() ?? 0,
      winAmount: winChecker ?? '0',
      readableWinAmount: map['readable_winning_amount'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory BetSoldOut.fromJson(String source) =>
      BetSoldOut.fromMap(json.decode(source));

  @override
  List<Object> get props => [
        id,
        soldOutNumber,
        winAmount,
        readableWinAmount,
      ];
}
