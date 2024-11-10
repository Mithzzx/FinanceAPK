class Budget {
  final int? id;
  final String name;
  final double totalAmount;
  double spentAmount;
  final String period;
  final List<int> categoryIds;
  final String accountName;
  final bool overspendAlert;
  final bool alertAt75Percent;

  Budget({
    this.id,
    required this.name,
    required this.totalAmount,
    this.spentAmount = 0.0,
    required this.period,
    required this.categoryIds,
    required this.accountName,
    required this.overspendAlert,
    required this.alertAt75Percent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalAmount': totalAmount,
      'spentAmount': spentAmount,
      'period': period,
      'categoryIds': categoryIds.join(','), // Store as comma-separated string
      'accountName': accountName,
      'overspendAlert': overspendAlert ? 1 : 0,
      'alertAt75Percent': alertAt75Percent ? 1 : 0,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      name: map['name'],
      totalAmount: map['totalAmount'],
      spentAmount: map['spentAmount'],
      period: map['period'],
      categoryIds: map['categoryIds'].toString().split(',').map((e) => int.parse(e)).toList(),
      accountName: map['accountName'],
      overspendAlert: map['overspendAlert'] == 1,
      alertAt75Percent: map['alertAt75Percent'] == 1,
    );
  }
}