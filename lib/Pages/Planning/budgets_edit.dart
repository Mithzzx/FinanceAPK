import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/accounts.dart';
import '../../backend/budgets.dart';
import '../../backend/database_helper.dart';
import '../categories_selection_page.dart';

class EditBudgetPage extends StatefulWidget {
  final Budget budget;

  const EditBudgetPage({Key? key, required this.budget}) : super(key: key);

  @override
  _EditBudgetPageState createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _totalAmount;
  late String _period;
  late List<int> _selectedCategoryIds;
  late String _selectedAccount;
  late bool _overspendAlert;
  late bool _alertAt75Percent;

  @override
  void initState() {
    super.initState();
    _name = widget.budget.name;
    _totalAmount = widget.budget.totalAmount;
    _period = widget.budget.period;
    _selectedCategoryIds = widget.budget.categoryIds;
    _selectedAccount = widget.budget.accountName;
    _overspendAlert = widget.budget.overspendAlert;
    _alertAt75Percent = widget.budget.alertAt75Percent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              await context.read<FinanceState>().deleteBudget(widget.budget.id!);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              initialValue: _name,
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
              initialValue: _totalAmount.toString(),
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
                  items: snapshot.data!.map((account) {
                    return DropdownMenuItem<String>(
                      value: account.name,
                      child: Text(account.name),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedAccount = value!),
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
                child: const Text('Update Budget'),
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

      final budget = Budget(
        id: widget.budget.id,
        name: _name,
        totalAmount: _totalAmount,
        period: _period,
        categoryIds: _selectedCategoryIds,
        accountName: _selectedAccount,
        overspendAlert: _overspendAlert,
        alertAt75Percent: _alertAt75Percent,
      );

      try {
        await context.read<FinanceState>().updateBudget(budget);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating budget: $e')),
        );
      }
    }
  }
}