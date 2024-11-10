import 'package:flutter/material.dart';
import '../../backend/database_helper.dart';
import '../../backend/goals.dart';
import 'package:provider/provider.dart';
import 'goal_view.dart';
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
              double progress = goal.savedAmount / goal.targetAmount;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(goal.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold
                      )
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${goal.savedAmount.toStringAsFixed(2)}'),
                          Text('${(progress * 100).toStringAsFixed(1)}% saved'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        minHeight: 7,
                        value: progress,
                        backgroundColor: goal.color.withOpacity(0.2),
                        color: goal.color,
                      ),
                      const SizedBox(height: 7),
                    ],
                  ),
                  leading: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: goal.color,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      goal.icon.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoalViewPage(goal: goal)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}