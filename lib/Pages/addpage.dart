import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../backend/database_helper.dart';
import '../backend/records.dart';
import '../backend/Categories.dart';
import 'categories_page.dart';

class AddTransactionPage extends StatefulWidget {
  final Category? selectedCategory;
  final SubCategory? selectedSubCategory;

  const AddTransactionPage({
    super.key,
    this.selectedCategory,
    this.selectedSubCategory,
  });

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedAccount;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  DateTime _selectedDate = DateTime.now();
  final PageController _accountPageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _selectedSubCategory = widget.selectedSubCategory;
    _amountController.text = '0.00';
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
    List<bool> _selectedRecordType = [true, false, false]; // Default to 'Income'

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Account Selection with Sliding Cards
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _accountPageController,
                itemCount: financeState.accounts.length,
                itemBuilder: (context, index) {
                  final account = financeState.accounts[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAccount = account.name;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [account.color.withOpacity(0.8), account.color.withOpacity(0.3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            account.accountType.icon,
                            size: 50,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            account.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            '\$${account.balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Segment Bar
            AppinioAnimatedToggleTab(
              height: 35,
              tabTexts: const ['Income', 'Expense', 'Transfer'],
              callback: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedRecordType.length; i++) {
                    _selectedRecordType[i] = i == index;
                  }
                });
              },
              width: MediaQuery.of(context).size.width * 0.9,
              boxDecoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              animatedBoxDecoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              activeStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              inactiveStyle: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.normal,
              ),
            ),

            const SizedBox(height: 20),

            // Category Selection
            GestureDetector(
              onTap: _navigateToCategorySelection,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: _selectedCategory?.color ?? Colors.grey,
                    child: _selectedCategory?.icon ?? const Icon(Icons.category, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedCategory?.name ?? 'Select Category',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedSubCategory != null)
                    Text(
                      _selectedSubCategory!.name,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Amount Input
            GestureDetector(
              onTap: () {
                // Logic to show a number pad or custom input method
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '\$${_amountController.text}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Add transaction logic here
              if (_selectedAccount != null &&
                  _selectedCategory != null &&
                  double.tryParse(_amountController.text) != null) {
                // Process transaction
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all details')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Add Record',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}