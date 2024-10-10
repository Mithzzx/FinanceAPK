import 'package:flutter/material.dart';

class BudgetsPage extends StatefulWidget {
  @override
  State<BudgetsPage> createState() => BudgetsPageState();
}

class BudgetsPageState extends State<BudgetsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: const Center(
        child: Text('Welcome Budgets Page!'),
      ),
      );
  }
}