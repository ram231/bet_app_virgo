import 'dart:convert';

import 'package:equatable/equatable.dart';

class BetBluetoothDevice extends Equatable {
  final String name;
  final String address;
  final int type;
  final bool connected;
  const BetBluetoothDevice({
    required this.name,
    required this.address,
    this.type = 0,
    this.connected = false,
  });

  BetBluetoothDevice copyWith({
    String? name,
    String? address,
    int? type,
    bool? connected,
  }) {
    return BetBluetoothDevice(
      name: name ?? this.name,
      address: address ?? this.address,
      type: type ?? this.type,
      connected: connected ?? this.connected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'type': type,
      'connected': connected,
    };
  }

  factory BetBluetoothDevice.fromMap(Map<String, dynamic> map) {
    return BetBluetoothDevice(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      type: map['type']?.toInt() ?? 0,
      connected: map['connected'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory BetBluetoothDevice.fromJson(String source) =>
      BetBluetoothDevice.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BetBluetoothDevice(name: $name, address: $address, type: $type, connected: $connected)';
  }

  @override
  List<Object> get props => [name, address, type, connected];
}
