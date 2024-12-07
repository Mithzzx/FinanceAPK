class Debt {
  final int? id;
  final String name;
  final String? description;
  final String accountName;
  final double amount;
  final DateTime date;
  final DateTime dueDate;

  Debt({
    this.id,
    required this.name,
    this.description,
    required this.accountName,
    required this.amount,
    required this.date,
    required this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'accountName': accountName,
      'amount': amount,
      'date': date.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
    };
  }

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      accountName: map['accountName'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      dueDate: DateTime.parse(map['dueDate']),
    );
  }
}