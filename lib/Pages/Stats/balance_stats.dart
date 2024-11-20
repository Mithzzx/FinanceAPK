import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../backend/database_helper.dart';
import '../../backend/records.dart';
import '../../backend/accounts.dart';

class BalanceStatsPage extends StatefulWidget {
  const BalanceStatsPage({super.key});

  @override
  State<BalanceStatsPage> createState() => _BalanceStatsPageState();
}

class _BalanceStatsPageState extends State<BalanceStatsPage> {
  String selectedPeriod = '1W';
  final List<String> periods = ['1W', '1M', '3M', '1Y', 'ALL'];

  List<FlSpot> _getChartData(List<Record> records, List<Account> accounts, String period) {
    final now = DateTime.now();
    DateTime startDate;

    // Determine start date based on selected period
    switch (period) {
      case '1W':
        startDate = now.subtract(const Duration(days: 7));
      case '1M':
        startDate = DateTime(now.year, now.month - 1, now.day);
      case '3M':
        startDate = DateTime(now.year, now.month - 3, now.day);
      case '1Y':
        startDate = DateTime(now.year - 1, now.month, now.day);
      case 'ALL':
        startDate = DateTime(2000); // Far past date to include all records
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    // Get current total balance from accounts
    final currentBalance = accounts.fold(0.0, (sum, account) => sum + account.balance);

    // Sort records by date in ascending order
    final relevantRecords = records
        .where((record) => record.dateTime.isAfter(startDate))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    // Create a map of daily balances starting from current balance
    final Map<DateTime, double> dailyBalances = {};
    var runningBalance = currentBalance;

    // Work backwards from current balance using records
    for (var record in relevantRecords) {
      final date = DateTime(
        record.dateTime.year,
        record.dateTime.month,
        record.dateTime.day,
      );

      // Subtract the record amount since we're going backwards in time
      runningBalance -= record.amount;

      // Store the running balance for this date
      dailyBalances[date] = runningBalance;
    }

    // Convert to list of spots for the chart
    final List<FlSpot> spots = [];
    var daysToShow = now.difference(startDate).inDays;
    runningBalance = currentBalance;

    // Create spots for each day in the period
    for (var i = 0; i <= daysToShow; i++) {
      final date = DateTime(
        now.year,
        now.month,
        now.day - (daysToShow - i),
      );

      // If we have a balance for this date, use it
      if (dailyBalances.containsKey(date)) {
        runningBalance = dailyBalances[date]!;
      }

      spots.add(FlSpot(
        i.toDouble(),
        runningBalance,
      ));
    }

    return spots;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Statistics'),
      ),
      body: Consumer<FinanceState>(
        builder: (context, financeState, child) {
          final spots = _getChartData(
            financeState.records,
            financeState.accounts,
            selectedPeriod,
          );

          final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 200;
          final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 100;

          return Column(
            children: [
              // Period selector
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SegmentedButton<String>(
                  segments: periods.map((period) =>
                      ButtonSegment<String>(
                        value: period,
                        label: Text(period),
                      )
                  ).toList(),
                  selected: {selectedPeriod},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      selectedPeriod = newSelection.first;
                    });
                  },
                ),
              ),

              // Summary content moved above the graph
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.currency(symbol: '\$').format(
                            spots.last.y,
                          ),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Change',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.currency(symbol: '\$').format(
                            spots.last.y - spots.first.y,
                          ),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: spots.last.y >= spots.first.y
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Balance chart
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
                    LineChartData(
                      minY: minY,
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: true,
                        horizontalInterval: (maxY - minY) / 6,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.1),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.1),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  NumberFormat.compact().format(value),
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              final date = DateTime.now().subtract(
                                Duration(days: (spots.length - 1 - value.toInt())),
                              );
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
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: Theme.of(context).colorScheme.primary,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                Theme.of(context).colorScheme.primary.withOpacity(0.05),
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
                                Duration(days: (spots.length - 1 - spot.x.toInt())),
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
          );
        },
      ),
    );
  }
}