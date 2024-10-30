
import 'package:finance_apk/backend/accounts.dart';
import 'package:flutter/material.dart';
import 'Categories.dart';

class Label {
  final String name;

  Label({required this.name});
}

class Record {
  int? id;
  double amount;
  Account account;
  Category category;
  DateTime dateTime;
  String? label;
  String? notes;
  String? payee;
  String? paymentType;
  String? warranty;
  String? status;
  String? location;
  String? photo;

  Record({
    this.id,
    required this.amount,
    required this.account,
    required this.category,
    required this.dateTime,
    this.label,
    this.notes,
    this.payee,
    this.paymentType,
    this.warranty,
    this.status,
    this.location,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'categoryId': category.id,
      'dateTime': dateTime.toIso8601String(),
      'label': label?.isNotEmpty == true ? label : null,
      'notes': notes,
      'payee': payee,
      'paymentType': paymentType,
      'warranty': warranty,
      'status': status,
      'location': location,
      'photo': photo,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      amount: map['amount'],
      account: accounts.firstWhere(
            (account) => account.name == map['accountName'],
        orElse: () => throw Exception('Account not found: ${map['accountName']}'),
      ),
      category: categories.firstWhere(
            (category) => category.id == map['categoryId'],
        orElse: () => Category(id: 0, name: 'Unknown', icon: const Icon(Icons.error), color: Colors.grey),
      ),
      dateTime: DateTime.parse(map['dateTime']),
      label: map['label'] != null ? map['label'] : null,
      notes: map['notes'],
      payee: map['payee'],
      paymentType: map['paymentType'],
      warranty: map['warranty'],
      status: map['status'],
      location: map['location'],
      photo: map['photo'],
    );
  }
}
List<Record> Records = [];