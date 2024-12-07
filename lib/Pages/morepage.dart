import 'package:finance_apk/Pages/recordspage.dart';
import 'package:flutter/material.dart';

import 'debts_page.dart';

class MorePage extends StatefulWidget {
  @override
  State<MorePage> createState() => MorePageState();
}

class MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: GridView.count(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 7 / 6, // Adjusted aspect ratio to reduce card height
          children: [
            _buildCard(
                'Records',
                Icons.record_voice_over,
                const Color.fromARGB(255, 55, 181, 149),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecordsPage()),
                  );
                }
            ),
            _buildCard(
                'Support & Donate',
                Icons.favorite,
                const Color.fromARGB(255, 221, 116, 179),
                    () {
                  // Add navigation or action for Support & Donate card
                }
            ),
            _buildCard(
                'Debt',
                Icons.money_off,
                const Color.fromARGB(255, 255, 87, 34),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DebtsPage()),
                  );
                }
            ),
            _buildCard(
                'Settings',
                Icons.settings,
                const Color.fromARGB(255, 33, 150, 243),
                    () {
                  // Add navigation or action for Settings card
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color iconBgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 1,
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconBgColor, // Set the background color
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(13), // Rounded edges
                ),
                child: Icon(
                  icon, // Placeholder icon
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}