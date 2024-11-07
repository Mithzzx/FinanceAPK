import 'package:flutter/material.dart';

class AccountType {
  String name;
  IconData icon;

  AccountType({
    required this.name,
    required this.icon
  });
}

class AccountTypes {
  AccountType savings = AccountType(name: "Savings", icon: Icons.macro_off_sharp);
  AccountType checking = AccountType(name: "Checking", icon: Icons.money);
  AccountType business = AccountType(name: "Business", icon: Icons.account_balance_outlined);
  AccountType investment = AccountType(name: "Investment", icon: Icons.model_training);
  AccountType retirement = AccountType(name: "Retirement", icon: Icons.add_alert_rounded);
  AccountType other = AccountType(name: "Other", icon: Icons.account_circle_rounded);

  List<AccountType> getAllAccountTypes() {
    return [savings, checking, business, investment, retirement, other];
  }
}

AccountTypes accountTypes = AccountTypes();

// Database Models
class Account {
  final String name;
  final String currency;
  final double balance;
  final int accountNumber;
  final AccountType accountType;
  final Color color;

  Account({
    required this.name,
    required this.currency,
    required this.balance,
    required this.accountNumber,
    required this.accountType,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'currency': currency,
      'balance': balance,
      'accountNumber': accountNumber,
      'accountType': accountTypes.getAllAccountTypes().firstWhere((element) => element.name == accountType.name).name,
      'color': color.value,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      name: map['name'],
      currency: map['currency'],
      balance: map['balance'],
      accountNumber: map['accountNumber'],
      accountType: accountTypes.getAccountTypeByName(map['accountType']),
      color: Color(map['color']),
    );
  }
}

extension AccountTypesExtension on AccountTypes {
  AccountType getAccountTypeByName(String name) {
    switch (name) {
      case 'Savings':
        return savings;
      case 'Checking':
        return checking;
      case 'Business':
        return business;
      case 'Investment':
        return investment;
      case 'Retirement':
        return retirement;
      default:
        return other;
    }
  }
}

List<Account> accounts = [];


