// lib/Components/recent_records_card.dart
import 'package:flutter/material.dart';
import '../Pages/recordspage.dart';
import '../backend/Records.dart';

class RecentRecordsCard extends StatelessWidget {
  RecentRecordsCard();

  @override
  Widget build(BuildContext context) {
    // Sort records by date
    Records.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    // Get the recent 5 records
    List<Record> recentRecords = Records.take(5).toList();

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
<<<<<<< HEAD
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: const Divider(height: 1, thickness: 0.3),
                ), // Separator between title and list
                ...recentRecords.map((record) {
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: record.category.color,
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: IconTheme(
                        data: const IconThemeData(color: Colors.white),
                        child: record.category.icon,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record.category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
=======
>>>>>>> parent of fb801ae (Accounts DataBase)
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: const Divider(height: 1,thickness: 0.3,),
          ), // Separator between title and list
          ...recentRecords.map((record) {
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: record.category.color,
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white),
                  child: record.category.icon,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(record.account.name, style: const TextStyle(color: Colors.grey, fontSize: 14)),
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
}