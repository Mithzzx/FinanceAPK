import 'dart:math';
import 'package:finance_apk/backend/accounts.dart';
import 'Categories.dart';

class Label {
  final String name;

  Label({required this.name});
}

class Record {
  final double amount;
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
  final String? photo;

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
    this.photo,
  });
}

List<Record> generateRandomRecords(int count) {
  final random = Random();
  final paymentTypes = ['Credit Card', 'Debit Card', 'Cash'];
  final statuses = ['Active', 'Pending', 'Completed'];
  final locations = ['Walmart', 'Shell', 'AMC', 'CVS', 'Macy\'s', 'Marriott', 'McDonald\'s'];
  final notes = [
    'Bought some groceries',
    'Filled up the gas tank',
    'Watched a movie',
    'Bought some medicine',
    'Bought some clothes',
    'Stayed at a hotel',
    'Ate at a restaurant'
  ];
  final payees = ['Walmart', 'Shell', 'AMC', 'CVS', 'Macy\'s', 'Marriott', 'McDonald\'s'];

  return List.generate(count, (index) {
    return Record(
      amount: random.nextDouble() * 1000,
      account: accounts[random.nextInt(accounts.length)],
      category: categories[random.nextInt(categories.length)],
      dateTime: DateTime.now().subtract(Duration(days: random.nextInt(30))),
      label: Label(name: 'Label ${index + 1}'),
      notes: notes[random.nextInt(notes.length)],
      payee: payees[random.nextInt(payees.length)],
      paymentType: paymentTypes[random.nextInt(paymentTypes.length)],
      warranty: '${random.nextInt(5) + 1} year',
      status: statuses[random.nextInt(statuses.length)],
      location: locations[random.nextInt(locations.length)],
      photo: 'photo${index + 1}.jpg',
    );
  });
}

List<Record> Records = generateRandomRecords(10);