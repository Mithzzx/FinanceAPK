class Record {
  final int? id;
  final double amount;
  final String accountName;
  final int categoryId;
  final DateTime dateTime;
  final String? label;
  final String? notes;
  final String? payee;
  final String? paymentType;

  Record({
    this.id,
    required this.amount,
    required this.accountName,
    required this.categoryId,
    required this.dateTime,
    this.label,
    this.notes,
    this.payee,
    this.paymentType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'accountName': accountName,
      'categoryId': categoryId,
      'dateTime': dateTime.toIso8601String(),
      'label': label,
      'notes': notes,
      'payee': payee,
      'paymentType': paymentType,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      amount: map['amount'],
      accountName: map['accountName'],
      categoryId: map['categoryId'],
      dateTime: DateTime.parse(map['dateTime']),
      label: map['label'],
      notes: map['notes'],
      payee: map['payee'],
      paymentType: map['paymentType'],
    );
  }
}