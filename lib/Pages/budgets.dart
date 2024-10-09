// lib/new_page.dart

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:finance_apk/Components/AppBar/appbar1.dart';
import 'package:finance_apk/main.dart';
import 'package:flutter/material.dart';

MyHomePageState myHomePage = MyHomePageState();
class BudgetsPage extends StatefulWidget {
  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: const Center(
        child: Text('Welcome Budgets Page!'),
      ),
      bottomNavigationBar:bottomNavBar1(Theme.of(context)),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 17), // Move the button down
        child: FloatingActionButton(
          onPressed: () {
            //_onItemTapped(2); // Center button taps to "Add Page"
          },
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
