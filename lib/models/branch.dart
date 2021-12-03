import 'dart:convert';

import 'package:equatable/equatable.dart';

class BetBranch extends Equatable {
  final int id;
  final String name;
  BetBranch({
    required this.id,
    required this.name,
  });

  BetBranch copyWith({
    int? id,
    String? name,
  }) {
    return BetBranch(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory BetBranch.fromMap(Map<String, dynamic> map) {
    return BetBranch(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BetBranch.fromJson(String source) =>
      BetBranch.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name];
}
