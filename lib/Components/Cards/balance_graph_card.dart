import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../Pages/theme_provider.dart';
import '../../backend/database_helper.dart';

class AccountBalanceGraph extends StatefulWidget {
  @override
  _AccountBalanceGraphState createState() => _AccountBalanceGraphState();
}

class _AccountBalanceGraphState extends State<AccountBalanceGraph> {
  List<FlSpot> _balanceData = [];
  double percentageChange = 0.0;
  bool isIncrease = true;

  @override
  void initState() {
    super.initState();
    _fetchAccountBalances();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

    Map<DateTime, double> dailyBalances = {};
    double runningBalance = totalBalance;

    // Add today's balance
    dailyBalances[today] = totalBalance;

    // Calculate balances for past days
    for (var i = 0; i < 30; i++) {
      final date = today.subtract(Duration(days: i));
      final dateOnly = DateTime(date.year, date.month, date.day);

      for (final record in records) {
        if (DateFormat('yyyy-MM-dd').format(record.dateTime) ==
            DateFormat('yyyy-MM-dd').format(date)) {
          runningBalance -= record.amount;
        }
      }

      dailyBalances[dateOnly] = runningBalance;
    }

    // Convert to FlSpots
    final spots = dailyBalances.entries
        .map((entry) => FlSpot(
      30 - today.difference(entry.key).inDays.toDouble(),
      entry.value,
    ))
        .toList();

    spots.sort((a, b) => a.x.compareTo(b.x));

    final initialBalance = spots.first.y;
    final currentTotalBalance = spots.last.y;
    percentageChange = ((currentTotalBalance - initialBalance) / initialBalance) * 100;
    isIncrease = percentageChange >= 0;

    setState(() {
      _balanceData = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_balanceData.isEmpty) {
      return const Card(
        elevation: 2,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final minY = _balanceData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 200;
    final maxY = _balanceData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 100;
    final brightColor = Provider.of<ThemeProvider>(context).lighterColor;
    final currentTotalBalance = _balanceData.last.y;

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 3, right: 8, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ACCOUNT BALANCE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to detailed view
                      },
                      child: const Row(
                        children: [
                          Text(
                            'SHOW MORE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Divider(height: 1,),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '\$${currentTotalBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Last 30 Days',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${percentageChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isIncrease ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                  ),
                ),
                Icon(
                  isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isIncrease ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: LineChart(
                LineChartData(
                  minX: 1, // Start from 1 to remove the first plot
                  maxX: 30,
                  minY: minY,
                  maxY: maxY,
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value == 1) return const Text(''); // Skip the first label
                          final date = DateTime.now().subtract(Duration(days: (30 - value).round()));
                          return Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              DateFormat('MM/dd').format(date),
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _balanceData.where((spot) => spot.x > 0).toList(),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: brightColor,
                      barWidth: 2.5,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            brightColor.withOpacity(0.15),
                            brightColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (spot) => Theme.of(context).colorScheme.primaryContainer,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final date = DateTime.now().subtract(
                            Duration(days: (30 - spot.x).round()),
                          );
                          return LineTooltipItem(
                            '${DateFormat('MMM d').format(date)}\n\$${spot.y.toStringAsFixed(2)}',
                            TextStyle(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}