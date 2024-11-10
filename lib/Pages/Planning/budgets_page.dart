import 'package:flutter/material.dart';
import '../../backend/budgets.dart';
import '../../backend/database_helper.dart';
import 'budget_add.dart';
import 'package:provider/provider.dart';
import 'budget_view.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  @override
  void initState() {
    super.initState();
    // Update budgets when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinanceState>().updateBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddBudgetPage()),
              );
              // Update budgets after returning from add page
              if (mounted) {
                context.read<FinanceState>().updateBudgets();
              }
            },
          ),
        ],
      ),
      body: Consumer<FinanceState>(
        builder: (context, financeState, child) {
          return FutureBuilder<List<Budget>>(
            future: financeState.getBudgets(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final budgets = snapshot.data!;
              if (budgets.isEmpty) {
                return const Center(
                  child: Text('No budgets yet. Tap + to create one.'),
                );
              }

              final groupedBudgets = {
                'weekly': budgets.where((b) => b.period == 'weekly').toList(),
                'monthly': budgets.where((b) => b.period == 'monthly').toList(),
                'yearly': budgets.where((b) => b.period == 'yearly').toList(),
                'onetime': budgets.where((b) => b.period == 'onetime').toList(),
              };

              return ListView.builder(
                itemCount: groupedBudgets.length,
                itemBuilder: (context, index) {
                  final period = groupedBudgets.keys.elementAt(index);
                  final periodBudgets = groupedBudgets[period]!;

                  if (periodBudgets.isEmpty) return const SizedBox.shrink();

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                period.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                        ...periodBudgets.map((budget) {
                          final remainingAmount = budget.totalAmount - budget.spentAmount;
                          final percentageLeft = (remainingAmount / budget.totalAmount * 100).clamp(0, 100);

                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      budget.name,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '₹${remainingAmount.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${percentageLeft.toStringAsFixed(1)}% left',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                minHeight: 14,
                                value: budget.spentAmount / budget.totalAmount,
                                backgroundColor: Colors.grey[800],
                                valueColor: AlwaysStoppedAnimation(
                                  budget.spentAmount >= budget.totalAmount ? Colors.red :
                                  budget.spentAmount / budget.totalAmount >= 0.75 ? Colors.orange :
                                  Colors.green,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BudgetViewPage(budget: budget),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}