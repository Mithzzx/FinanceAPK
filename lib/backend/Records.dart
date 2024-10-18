import 'package:finance_apk/backend/accounts.dart'; // Adjust the import path as necessary

class Category {
  final String name;

  Category({required this.name});
}
class Label {
  final String name;

  Label({required this.name});
}

class Record {
  final bool amount;
  final Account account;
  final Category category;
  final DateTime dateTime;
  final Label label;
  final String notes;
  final String payee;
  final String paymentType;
  final String warranty;
  final String status;
  final String location;
  final String photo;

  Record({
    required this.amount,
    required this.account,
    required this.category,
    required this.dateTime,
    required this.label,
    required this.notes,
    required this.payee,
    required this.paymentType,
    required this.warranty,
    required this.status,
    required this.location,
    required this.photo,
  });
}