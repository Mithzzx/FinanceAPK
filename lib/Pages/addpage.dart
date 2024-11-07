import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/Categories.dart';
import '../backend/Categories.dart';
import '../backend/database_helper.dart';
import '../backend/records.dart';
import '../backend/accounts.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String _selectedTransactionType = 'Income';
  String? _selectedAccount;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Consumer<FinanceState>(
        builder: (context, financeState, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedAccount,
                  items: financeState.accounts.map((account) {
                    return DropdownMenuItem(
                      value: account.name,
                      child: Text(account.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccount = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Account'),
                ),
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                ListTile(
                  title: Text(
                    'Date: ${DateFormat.yMd().format(_selectedDate)}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final record = Record(
                        amount: double.parse(_amountController.text),
                        accountName: _selectedAccount!,
                        categoryId: _selectedCategory!.id,
                        dateTime: _selectedDate,
                      );
                      await financeState.addRecord(record);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Transaction'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
