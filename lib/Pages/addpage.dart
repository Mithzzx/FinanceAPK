import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/database_helper.dart';
import '../backend/records.dart';
import '../backend/Categories.dart';
import 'categoriespage.dart';

class AddTransactionPage extends StatefulWidget {
  final Category? selectedCategory;
  final SubCategory? selectedSubCategory;

  const AddTransactionPage({
    Key? key,
    this.selectedCategory,
    this.selectedSubCategory,
  }) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _labelController = TextEditingController();
  final _notesController = TextEditingController();
  final _payeeController = TextEditingController();

  String? _selectedAccount;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  String _selectedPaymentType = 'Cash';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<String> _paymentTypes = ['Cash', 'Card', 'Transfer', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _selectedSubCategory = widget.selectedSubCategory;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _labelController.dispose();
    _notesController.dispose();
    _payeeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _navigateToCategorySelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoriesPage(),
      ),
    );
    if (result != null && result is Category) {
      setState(() {
        _selectedCategory = result;
        _selectedSubCategory = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final financeState = Provider.of<FinanceState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Record'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedAccount,
                decoration: const InputDecoration(
                  labelText: 'Account',
                  prefixIcon: Icon(Icons.account_balance),
                ),
                items: financeState.accounts.map((account) {
                  return DropdownMenuItem(
                    value: account.name,
                    child: Text(account.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAccount = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an account';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Selection
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: _selectedCategory?.color ?? Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: IconTheme(
                    data: const IconThemeData(color: Colors.white),
                    child: _selectedCategory?.icon ?? const Icon(Icons.category),
                  ),
                ),
                title: Text(_selectedCategory?.name ?? 'Select Category'),
                subtitle: _selectedSubCategory != null
                    ? Text(_selectedSubCategory!.name)
                    : null,
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _navigateToCategorySelection,
              ),
              const SizedBox(height: 16),

              // Date and Time Selection
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                      ),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(
                        'Time: ${_selectedTime.format(context)}',
                      ),
                      onTap: () => _selectTime(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedPaymentType,
                decoration: const InputDecoration(
                  labelText: 'Payment Type',
                  prefixIcon: Icon(Icons.payment),
                ),
                items: _paymentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: 'Label',
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _payeeController,
                decoration: const InputDecoration(
                  labelText: 'Payee',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _selectedCategory != null) {
                    final DateTime combinedDateTime = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    );

                    final record = Record(
                      amount: double.parse(_amountController.text),
                      accountName: _selectedAccount!,
                      categoryId: _selectedCategory!.id,
                      dateTime: combinedDateTime,
                      label: _labelController.text,
                      notes: _notesController.text,
                      payee: _payeeController.text,
                      paymentType: _selectedPaymentType,
                    );

                    await financeState.addRecord(record);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Add Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}