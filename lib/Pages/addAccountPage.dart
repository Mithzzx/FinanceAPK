import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:finance_apk/backend/accounts.dart';
import '../Services/database_service.dart';

class AddAccountPage extends StatefulWidget {
  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _accountName = '';
  double _balance = 0.0;
  IconData _selectedIcon = Icons.account_balance;
  Color _selectedColor = Colors.blue;
  AccountType _selectedAccountType = accountTypes.savings;

  final List<IconData> _icons = [
    Icons.account_balance,
    Icons.credit_card,
    Icons.savings,
    Icons.wallet_travel,
  ];

  void _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> account = {
        'name': _accountName,
        'currency': 'USD', // Assuming currency is USD for now
        'balance': _balance,
        'accountNumber': 1234567890, // Assuming a dummy account number for now
        'accountType': _selectedAccountType.name,
        'color': _selectedColor.value,
      };
      await DatabaseHelper().insertAccount(account);
      Navigator.pop(context);
    }
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Account Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an account name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Balance'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a balance';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _balance = double.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<IconData>(
                decoration: const InputDecoration(labelText: 'Select Icon'),
                value: _selectedIcon,
                items: _icons.map((icon) {
                  return DropdownMenuItem<IconData>(
                    value: icon,
                    child: Icon(icon),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIcon = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<AccountType>(
                decoration: const InputDecoration(labelText: 'Select Account Type'),
                value: _selectedAccountType,
                items: [
                  accountTypes.savings,
                  accountTypes.checking,
                  accountTypes.business,
                  accountTypes.investment,
                  accountTypes.retirement,
                  accountTypes.other,
                ].map((accountType) {
                  return DropdownMenuItem<AccountType>(
                    value: accountType,
                    child: Text(accountType.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Select Color:'),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _pickColor,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: _selectedColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAccount,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}