import 'records.dart';

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

  // Add getters for start and end dates based on period
  DateTime get startDate {
    final now = DateTime.now();
    switch (period) {
      case 'weekly':
      // Start of current week (Sunday)
        return DateTime(now.year, now.month, now.day - now.weekday);
      case 'monthly':
      // Start of current month
        return DateTime(now.year, now.month, 1);
      case 'yearly':
      // Start of current year
        return DateTime(now.year, 1, 1);
      case 'onetime':
      default:
      // For one-time budgets, no specific start date
        return DateTime(1970);
    }
  }

  DateTime get endDate {
    final now = DateTime.now();
    switch (period) {
      case 'weekly':
      // End of current week (Saturday)
        return DateTime(now.year, now.month, now.day - now.weekday + 6, 23, 59, 59);
      case 'monthly':
      // End of current month
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case 'yearly':
      // End of current year
        return DateTime(now.year, 12, 31, 23, 59, 59);
      case 'onetime':
      default:
      // For one-time budgets, far future date
        return DateTime(9999);
    }
  }

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
      'categoryIds': categoryIds.join(','),
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

  // Method to check if a record falls within this budget's criteria
  bool matchesRecord(Record record) {
    return categoryIds.contains(record.categoryId) &&
        accountName == record.accountName &&
        record.dateTime.isAfter(startDate) &&
        record.dateTime.isBefore(endDate);
  }
}