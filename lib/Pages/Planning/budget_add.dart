import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/accounts.dart';
import '../../backend/budgets.dart';
import '../../backend/database_helper.dart';
import '../categories_selection_page.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  _AddBudgetPageState createState() => _AddBudgetPageState();
}


class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _totalAmount = 0.0;
  String _period = 'monthly';
  List<int> _selectedCategoryIds = [];
  String? _selectedAccount; // Changed to nullable
  bool _overspendAlert = false;
  bool _alertAt75Percent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Budget'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Budget Name'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Total Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value!) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => _totalAmount = double.parse(value!),
            ),
            DropdownButtonFormField<String>(
              value: _period,
              decoration: const InputDecoration(labelText: 'Period'),
              items: ['weekly', 'monthly', 'yearly', 'onetime']
                  .map((period) => DropdownMenuItem(
                value: period,
                child: Text(period.toUpperCase()),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _period = value!),
            ),
            ListTile(
              title: const Text('Select Categories'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final selectedIds = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategorySelectionPage(
                      initialSelection: _selectedCategoryIds,
                    ),
                  ),
                );
                if (selectedIds != null) {
                  setState(() => _selectedCategoryIds = selectedIds);
                }
              },
            ),
            FutureBuilder<List<Account>>(
              future: DatabaseHelper().getAccounts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return DropdownButtonFormField<String>(
                  value: _selectedAccount,
                  decoration: const InputDecoration(labelText: 'Account'),
                  hint: const Text('Select an account'), // Added hint
                  items: [
                    ...snapshot.data!.map(
                          (account) => DropdownMenuItem(
                        value: account.name,
                        child: Text(account.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedAccount = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an account';
                    }
                    return null;
                  },
                );
              },
            ),
            SwitchListTile(
              title: const Text('Overspend Alert'),
              value: _overspendAlert,
              onChanged: (value) => setState(() => _overspendAlert = value),
            ),
            SwitchListTile(
              title: const Text('Alert at 75%'),
              value: _alertAt75Percent,
              onChanged: (value) => setState(() => _alertAt75Percent = value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _saveBudget,
                child: const Text('Create Budget'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if account is selected
      if (_selectedAccount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an account')),
        );
        return;
      }

      // Check if categories are selected
      if (_selectedCategoryIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one category')),
        );
        return;
      }

      final budget = Budget(
        name: _name,
        totalAmount: _totalAmount,
        period: _period,
        categoryIds: _selectedCategoryIds,
        accountName: _selectedAccount!,
        overspendAlert: _overspendAlert,
        alertAt75Percent: _alertAt75Percent,
      );

      try {
        await context.read<FinanceState>().addBudget(budget);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating budget: $e')),
        );
      }
    }
  }
}
