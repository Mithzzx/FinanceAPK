import 'package:flutter/material.dart';

import '../Services/database_service.dart';

class AccountType {
  String name;
  IconData icon;

  AccountType({
    required this.name,
    required this.icon,
  });
}

class AccountTypes {
  AccountType savings = AccountType(name: "Savings", icon: Icons.macro_off_sharp);
  AccountType checking = AccountType(name: "Checking", icon: Icons.money);
  AccountType business = AccountType(name: "Business", icon: Icons.account_balance_outlined);
  AccountType investment = AccountType(name: "Investment", icon: Icons.model_training);
  AccountType retirement = AccountType(name: "Retirement", icon: Icons.add_alert_rounded);
  AccountType other = AccountType(name: "Other", icon: Icons.account_circle_rounded);
}

class Account {
  String name;
  String currency;
  double balance;
  double accountNumber;
  AccountType accountType;
  Color color;

  Account({
    required this.name,
    required this.currency,
    required this.balance,
    required this.accountNumber,
    required this.accountType,
    required this.color,
  });
}

AccountTypes accountTypes = AccountTypes();

void _saveAccount() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    Map<String, dynamic> account = {
      'name': _accountName,
      'balance': _balance,
      'icon': _selectedIcon.codePoint,
      'color': _selectedColor.value,
    };
    await DatabaseHelper().insertAccount(account);
    Navigator.pop(context);
  }
}


