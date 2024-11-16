import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../backend/database_helper.dart';

class AccountBalanceGraph extends StatefulWidget {
  @override
  _AccountBalanceGraphState createState() => _AccountBalanceGraphState();
}

class _AccountBalanceGraphState extends State<AccountBalanceGraph> {
  List<DateValueData> _accountBalanceData = [];

  @override
  void initState() {
    super.initState();
    _fetchAccountBalances();
  }

  Future<void> _fetchAccountBalances() async {
    final db = DatabaseHelper();
    final accounts = await db.getAccounts();
    final records = await db.getRecords();

    final today = DateTime.now();
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));

    double totalBalance = 0;
    for (final account in accounts) {
      totalBalance += account.balance;
    }

    final balanceData = <DateValueData>[];
    for (int i = 0; i < 30; i++) {
      final date = thirtyDaysAgo.add(Duration(days: i));
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      double dailyBalance = totalBalance;
      for (final record in records) {
        if (DateFormat('yyyy-MM-dd').format(record.dateTime) == dateString) {
          dailyBalance += record.amount;
        }
      }

      balanceData.add(DateValueData(date: dateString, value: dailyBalance));
    }

    setState(() {
      _accountBalanceData = balanceData.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_accountBalanceData.isNotEmpty)
              SizedBox(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    LineSeries<DateValueData, String>(
                      dataSource: _accountBalanceData,
                      xValueMapper: (DateValueData data, _) => data.date,
                      yValueMapper: (DateValueData data, _) => data.value,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

class DateValueData {
  final String date;
  final double value;

  DateValueData({
    required this.date,
    required this.value,
  });
}