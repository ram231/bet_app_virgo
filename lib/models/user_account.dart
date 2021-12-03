import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserAccount extends Equatable {
  final int id;
  final String firstName;
  final String type;
  final String middleName;
  final String lastName;
  final String sex;
  final String company;
  final String address;
  final String contactNumber;
  final String birthday;
  final int active;
  final String scheduleIn;
  final String scheduleOut;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String fullName;
  final int? branchId;
  UserAccount({
    required this.id,
    this.firstName = '',
    this.type = '',
    this.middleName = '',
    this.lastName = '',
    this.sex = '',
    this.company = '',
    this.address = '',
    this.contactNumber = '',
    this.birthday = '',
    this.active = 0,
    this.scheduleIn = '',
    this.scheduleOut = '',
    this.createdAt,
    this.updatedAt,
    this.fullName = '',
    this.branchId,
  });
  String get name => fullName;
  @override
  List<Object?> get props {
    return [
      id,
      firstName,
      type,
      middleName,
      lastName,
      sex,
      company,
      address,
      contactNumber,
      birthday,
      active,
      scheduleIn,
      scheduleOut,
      createdAt,
      updatedAt,
      fullName,
      branchId
    ];
  }

  UserAccount copyWith({
    int? id,
    String? firstName,
    String? type,
    String? middleName,
    String? lastName,
    String? sex,
    String? company,
    String? address,
    String? contactNumber,
    String? birthday,
    int? active,
    String? scheduleIn,
    String? scheduleOut,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fullName,
    int? branchId,
  }) {
    return UserAccount(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      type: type ?? this.type,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      sex: sex ?? this.sex,
      company: company ?? this.company,
      address: address ?? this.address,
      contactNumber: contactNumber ?? this.contactNumber,
      birthday: birthday ?? this.birthday,
      active: active ?? this.active,
      scheduleIn: scheduleIn ?? this.scheduleIn,
      scheduleOut: scheduleOut ?? this.scheduleOut,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fullName: fullName ?? this.fullName,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'type': type,
      'middle_name': middleName,
      'last_name': lastName,
      'sex': sex,
      'company': company,
      'address': address,
      'contact_number': contactNumber,
      'body': birthday,
      'active': active,
      'schedule_in': scheduleIn,
      'schedule_out': scheduleOut,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
      'full_name': fullName,
      'branch_id': branchId,
    };
  }

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      id: map['id'],
      firstName: map['first_name'] ?? '',
      type: map['type'] ?? '',
      middleName: map['middle_name'] ?? '',
      lastName: map['last_name'] ?? '',
      sex: map['sex'] ?? '',
      company: map['company'] ?? '',
      address: map['address'] ?? '',
      contactNumber: map['contact_number'] ?? '',
      birthday: map['body'] ?? '',
      active: map['active'] ?? 0,
      scheduleIn: map['schedule_in'] ?? '',
      scheduleOut: map['schedule_out'] ?? '',
      createdAt: map['created_at'] != null
          ? map['created_at'] is String
              ? DateTime.parse(map['created_at'])
              : DateTime.fromMillisecondsSinceEpoch(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? map['updated_at'] is String
              ? DateTime.parse(map['updated_at'])
              : DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
          : null,
      fullName: map['full_name'] ?? '',
      branchId: map['branch_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccount.fromJson(String source) =>
      UserAccount.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
