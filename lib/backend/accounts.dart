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
}

class Account{
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
    required this.color});
}
AccountTypes accountTypes = AccountTypes();
List<Account> accounts = [
  Account(name: "HDFC", currency: "USD", balance: 1500.75, accountNumber: 123456789,accountType: accountTypes.savings,color: Colors.blue),
  Account(name: "Fi", currency: "USD", balance: 2500.00, accountNumber: 987654321,accountType: accountTypes.checking, color: Colors.red),
  Account(name: "Axis", currency: "USD", balance: 5000.50, accountNumber: 112233445,accountType: accountTypes.business, color: Colors.green),
  Account(name: "Mutual Funds", currency: "USD", balance: 10000.00, accountNumber: 556677889,accountType: accountTypes.investment, color: Colors.orange),
  Account(name: "Crypto", currency: "USD", balance: 20000.00, accountNumber: 998877665,accountType: accountTypes.retirement, color: Colors.purple),
  Account(name: " Account", currency: "USD", balance: 20000.00, accountNumber: 998877665,accountType: accountTypes.savings, color: Colors.blueGrey),
];


