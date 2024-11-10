import 'package:flutter/material.dart';

import 'Planning/budgets_page.dart';
import 'Planning/goals_page.dart';

class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => PlanningPageState();
}

class PlanningPageState extends State<PlanningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Column(
          children: [
            buildCard('Budgets', 'Your spending plan', Icons.star, Colors.blue, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BudgetsPage()),
              );
            }),
            buildCard('Goals', 'Your saving plans', Icons.favorite, Colors.red, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GoalsPage()),
              );
            }),
            buildCard('Planned Payments', 'Your future payments', Icons.thumb_up, Colors.green, () {}),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 1.3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}