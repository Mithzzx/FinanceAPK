import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Pages/recordspage.dart';
import '../backend/records.dart';
import '../backend/database_helper.dart';
import '../backend/Categories.dart';
import 'package:intl/intl.dart';

class RecentRecordsCard extends StatelessWidget {
  const RecentRecordsCard({super.key});

  Widget _buildRecordTile(Record record) {
    final category = categories[record.categoryId];
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: category.color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: category.icon,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            record.accountName,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${record.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            DateFormat('HH:mm').format(record.dateTime),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.5, right: 15, top: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'LAST RECORDS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecordsPage(),
                ),
              );
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<FinanceState>(
        builder: (context, financeState, child) {
          if (financeState.records.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No records available'),
              ),
            );
          }

          // Get the most recent 5 records
          final recentRecords = List<Record>.from(financeState.records)
            ..sort((a, b) => b.dateTime.compareTo(a.dateTime))
            ..take(5);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(height: 1, thickness: 0.3),
              ),
              ...recentRecords.take(5).map(_buildRecordTile),
            ],
          );
        },
      ),
    );
  }
}