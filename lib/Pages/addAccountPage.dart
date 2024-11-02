import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../backend/database_helper.dart';
import '../backend/accounts.dart';

class AddAccountPage extends StatefulWidget {
  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _accountName = '';
  AccountType? _selectedAccountType;
  double _initialBalance = 0.0;
  String _currency = 'USD';
  double _accountNumber = 0.0;
  Color _color = Colors.blue;

  void _saveAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if the account name already exists
      List<Account> existingAccounts = await DatabaseHelper().getAccounts();
      bool nameExists = existingAccounts.any((account) => account.name == _accountName);

      if (nameExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account name already exists. Please choose a different name.')),
        );
        return;
      }

      // Create a new account object
      Account newAccount = Account(
        name: _accountName,
        currency: _currency,
        balance: _initialBalance,
        accountNumber: _accountNumber,
        accountType: _selectedAccountType!,
        color: _color,
      );

      // Insert the new account into the database
      await DatabaseHelper().insertAccount(newAccount);

      // Update the accounts list
      accounts = await DatabaseHelper().getAccounts();

      // Navigate back to the previous screen
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
              pickerColor: _color,
              onColorChanged: (color) {
                setState(() {
                  _color = color;
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
              DropdownButtonFormField<AccountType>(
                decoration: const InputDecoration(labelText: 'Account Type'),
                value: _selectedAccountType,
                items: accountTypes.getAllAccountTypes()
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an account type';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Initial Balance'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an initial balance';
                  }
                  return null;
                },
                onSaved: (value) {
                  _initialBalance = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Currency'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a currency';
                  }
                  return null;
                },
                onSaved: (value) {
                  _currency = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Account Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an account number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountNumber = double.parse(value!);
                },
              ),
              Row(
                children: [
                  const Text('Color:'),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _pickColor,
                    child: Container(
                      width: 24,
                      height: 24,
                      color: _color,
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