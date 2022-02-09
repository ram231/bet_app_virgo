import 'dart:convert';

import 'package:equatable/equatable.dart';

final fakeUserAccount = UserAccount.fromMap({
  "id": 3,
  "branch_id": 1,
  "first_name": "Kakashi",
  "middle_name": "",
  "last_name": "Hatake",
  "name_suffix": "",
  "fullname": "Kakashi Hatake",
  "type": "C",
  "type_text": "Cashier",
  "sex": "M",
  "sex_text": "Male",
  "company": "Bahringer Inc",
  "address": "23451 Brenna Passage, Sanfordton, 12259-4546",
  "contact_number": "(485) 719-3090",
  "birthday": "Aug 22, 1986",
  "age": 36,
  "salary": "544341.00",
  "salary_text": "₱544,341.00",
  "username": "cashier",
  "photo": "https://laravel-stl-games.com/",
  "active": 1,
  "consignee_amount": null,
  "consignee_paid_amt": null,
  "consignee_balance": null,
  "consignee_amount_text": null,
  "consignee_paid_amt_text": null,
  "consignee_balance_text": null,
  "schedule_in": "08:00:00",
  "schedule_out": "17:00:00",
  "created_at": "2022-01-05 19:34:40",
  "created_at_text": "Jan 05, 2022"
});

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
  const UserAccount({
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
      fullName: map['fullname'] ?? '',
      branchId: map['branch_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccount.fromJson(String source) =>
      UserAccount.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
