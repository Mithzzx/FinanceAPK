import 'package:flutter/material.dart';
import '../../backend/database_helper.dart';
import '../../backend/goals.dart';
import 'package:provider/provider.dart';
import 'goals_add.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGoalPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<FinanceState>(
        builder: (context, financeState, child) {
          List<Goal> goals = financeState.goals;

          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              Goal goal = goals[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(goal.name),
                  subtitle: Text('Target: ${goal.targetAmount}, Saved: ${goal.savedAmount}'),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: goal.color.withOpacity(0.2),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      goal.icon.icon,
                      color: goal.color,
                      size: 24,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}