import 'package:flutter/material.dart';
import '../backend/records.dart';
import 'package:intl/intl.dart';


class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  Widget build(BuildContext context) {
    // Sort records by date
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    // Group records by day
    Map<String, List<Record>> groupedRecords = {};
    for (var record in records) {
      String dateKey = DateFormat('yyyy-MM-dd').format(record.dateTime);
      if (!groupedRecords.containsKey(dateKey)) {
        groupedRecords[dateKey] = [];
      }
      groupedRecords[dateKey]!.add(record);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Records'),
      ),
      body: ListView(
        children: [
          ...groupedRecords.entries.map((entry) {
            String dateKey = entry.key;
            List<Record> records = entry.value;
            DateTime date = DateTime.parse(dateKey);
            String formattedDate = DateFormat('dd MMM').format(date).toUpperCase();
            if (date.year != DateTime.now().year) {
              formattedDate += ' ${date.year}';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      formattedDate,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
                ...records.map((record) {
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: record.category.color,
                        borderRadius: BorderRadius.circular(8.0),
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordDetailsPage(record: record),
                        ),
                      );
                    },
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}