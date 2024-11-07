import 'package:finance_apk/backend/Categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Pages/recordspage.dart';
import '../backend/records.dart';
import '../backend/database_helper.dart';

class RecentRecordsCard extends StatelessWidget {
  const RecentRecordsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FinanceState().loadData(), // Assuming this method returns a Future<List<Record>>
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Record> records = FinanceState().records;

          // Sort records by date
          records.sort((a, b) => b.dateTime.compareTo(a.dateTime));

          // Get the recent 5 records
          List<Record> recentRecords = records.take(5).toList();

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.5, right: 15, top: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'LAST RECORDS',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RecordsPage()));
                        },
                        child: const Text(
                          'SHOW MORE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: const Divider(height: 1, thickness: 0.3),
                ), // Separator between title and list
                ...recentRecords.map((record) {
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: categories[record.categoryId].color,
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: IconTheme(
                        data: const IconThemeData(color: Colors.white),
                        child: categories[record.categoryId].icon,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(categories[record.categoryId].name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(record.accountName, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the trailing column vertically
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${record.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '${record.dateTime.hour}:${record.dateTime.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }
      },
    );
  }
}