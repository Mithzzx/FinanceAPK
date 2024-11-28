import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';

import '../../backend/database_helper.dart';
import '../../backend/records.dart';

class BalanceStatsPage extends StatefulWidget {
  const BalanceStatsPage({super.key});

  @override
  _BalanceStatsPageState createState() => _BalanceStatsPageState();
}

class _BalanceStatsPageState extends State<BalanceStatsPage> {
  String selectedPeriod = '30 days';
  List<FlSpot> _balanceData = [];
  double currentBalance = 0.0;
  double percentageChange = 0.0;
  bool isIncrease = true;

  @override
  void initState() {
    super.initState();
    _fetchAccountBalances();
  }

  Future<void> _fetchAccountBalances() async {
    final db = DatabaseHelper();
    final accounts = await db.getAccounts();
    final records = await db.getRecords();

    currentBalance =
        accounts.fold(0.0, (sum, account) => sum + account.balance);

    final today = DateTime.now();
    Map<DateTime, double> dailyBalances = _calculateBalances(records, today);

    // Convert to FlSpots based on selected period
    final spots = _convertToSpots(dailyBalances, today);

    // Calculate percentage change
    final initialBalance = spots.first.y;
    final currentTotalBalance = spots.last.y;
    percentageChange =
        ((currentTotalBalance - initialBalance) / initialBalance) * 100;
    isIncrease = percentageChange >= 0;

    setState(() {
      _balanceData = spots;
    });
  }

  Map<DateTime, double> _calculateBalances(List<Record> records,
      DateTime today) {
    Map<DateTime, double> dailyBalances = {};
    final accounts = Provider
        .of<FinanceState>(context, listen: false)
        .accounts;
    double totalBalance = accounts.fold(
        0.0, (sum, account) => sum + account.balance);

    // Add today's balance
    dailyBalances[today] = totalBalance;

    int daysPeriod;
    switch (selectedPeriod) {
      case '7 days':
        daysPeriod = 7;
        break;
      case '30 days':
        daysPeriod = 30;
        break;
      case '12 weeks':
        daysPeriod = 84; // 12 * 7
        break;
      case '6 months':
        daysPeriod = 180;
        break;
      case '1 year':
        daysPeriod = 365;
        break;
      default:
        daysPeriod = 30;
    }

    double runningBalance = totalBalance;

    // Calculate balances
    for (var i = 0; i < daysPeriod; i++) {
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

    return dailyBalances;
  }

  List<FlSpot> _convertToSpots(Map<DateTime, double> dailyBalances,
      DateTime today) {
    List<FlSpot> spots;

    switch (selectedPeriod) {
      case '7 days':
        spots = _createSpots(dailyBalances, 7, (date) => date.day);
        break;
      case '30 days':
        spots = _createSpots(dailyBalances, 30, (date) => date.day);
        break;
      case '12 weeks':
        spots = _createWeeklySpots(dailyBalances, today);
        break;
      case '6 months':
        spots = _createMonthlySpots(dailyBalances, today);
        break;
      case '1 year':
        spots = _createMonthlySpots(dailyBalances, today, 12);
        break;
      default:
        spots = _createSpots(dailyBalances, 30, (date) => date.day);
    }

    return spots;
  }

  List<FlSpot> _createSpots(Map<DateTime, double> dailyBalances,
      int periodLength,
      int Function(DateTime) groupBy) {
    final today = DateTime.now();
    final spots = List.generate(periodLength, (i) {
      final date = today.subtract(Duration(days: periodLength - 1 - i));
      final dateKey = DateTime(date.year, date.month, date.day);

      final closestDate = dailyBalances.keys
          .where((key) => !key.isAfter(dateKey))
          .toList();

      closestDate.sort((a, b) => b.compareTo(a));

      return FlSpot(
          i.toDouble(),
          closestDate.isNotEmpty
              ? dailyBalances[closestDate.first]!
              : currentBalance
      );
    });

    return spots;
  }

  List<FlSpot> _createWeeklySpots(Map<DateTime, double> dailyBalances,
      DateTime today) {
    List<FlSpot> weeklySpots = [];

    for (int i = 0; i < 12; i++) {
      // Calculate the start and end of each week
      final weekEnd = today.subtract(Duration(days: i * 7));
      final weekStart = weekEnd.subtract(const Duration(days: 6));

      // Find the balance at the end of the week
      final weekEndBalance = dailyBalances.entries
          .where((entry) =>
      !entry.key.isBefore(weekStart) &&
          !entry.key.isAfter(weekEnd)
      )
          .toList();

      weekEndBalance.sort((a, b) => b.key.compareTo(a.key));

      final balance = weekEndBalance.isNotEmpty
          ? weekEndBalance.first.value
          : currentBalance;

      weeklySpots.add(FlSpot(11 - i.toDouble(), balance));
    }

    return weeklySpots;
  }

  List<FlSpot> _createMonthlySpots(Map<DateTime, double> dailyBalances,
      DateTime today, [int monthCount = 6]) {
    List<FlSpot> monthlySpots = [];

    for (int i = 0; i < monthCount; i++) {
      // Calculate the start of each month
      final monthStart = DateTime(today.year, today.month - i, 1);
      final monthEnd = DateTime(today.year, today.month - i + 1, 0);

      // Find the balance at the end of the month
      final monthEndBalance = dailyBalances.entries
          .where((entry) =>
      !entry.key.isBefore(monthStart) &&
          !entry.key.isAfter(monthEnd)
      )
          .toList();

      monthEndBalance.sort((a, b) => b.key.compareTo(a.key));

      final balance = monthEndBalance.isNotEmpty
          ? monthEndBalance.first.value
          : currentBalance;

      monthlySpots.add(FlSpot(monthCount - 1 - i.toDouble(), balance));
    }

    return monthlySpots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Statistics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            _buildBalanceSummary(),
            _buildBalanceChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AppinioAnimatedToggleTab(
        activeStyle: const TextStyle(color: Colors.white, fontSize: 13),
        inactiveStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        tabTexts: const ['7 days', '30 days', '12 weeks', '6 months', '1 year'],
        callback: (index) {
          setState(() {
            selectedPeriod =
            ['7 days', '30 days', '12 weeks', '6 months', '1 year'][index];
            _fetchAccountBalances();
          });
        },
        height: 50,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.95,
        boxDecoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(25),
        ),
        animatedBoxDecoration: BoxDecoration(
          color: Theme
              .of(context)
              .scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.symmetric(
            horizontal: BorderSide(
                color: Colors.grey.withOpacity(0.08), width: 3),
            vertical: BorderSide(
                color: Colors.grey.withOpacity(0.08), width: .8),
          ),
        ),
        initialIndex: 1, // Default to '30 days'
      ),
    );
  }

  Widget _buildBalanceSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$${currentBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                selectedPeriod,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge
                      ?.color
                      ?.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${percentageChange.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isIncrease ? Colors.green : Colors.red,
                ),
              ),
              Icon(
                isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                color: isIncrease ? Colors.green : Colors.red,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceChart() {
    if (_balanceData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final minY = _balanceData.map((spot) => spot.y).reduce((a, b) =>
    a < b
        ? a
        : b) - 200;
    final maxY = _balanceData.map((spot) => spot.y).reduce((a, b) =>
    a > b
        ? a
        : b) + 100;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: _balanceData.length.toDouble() - 1,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            verticalInterval: 1,
            horizontalInterval: (maxY - minY) / 5,
            getDrawingVerticalLine: (value) =>
                FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                ),
            getDrawingHorizontalLine: (value) =>
                FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY - minY) / 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return _getBottomTitleWidget(value.toInt());
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _balanceData,
              isCurved: true,
              curveSmoothness: 0.35,
              color: Colors.blue,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.withOpacity(0.15),
                    Colors.blue.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => Colors.white,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '\$${spot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.blue,
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
    );
  }

  Widget _getBottomTitleWidget(int index) {
    switch (selectedPeriod) {
      case '7 days':
        return Text(
          '${index + 1}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        );
      case '30 days':
        return Text(
          '${index + 1}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        );
      case '12 weeks':
        return Text(
          'W${12 - index}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        );
      case '6 months':
        return Text(
          'M${6 - index}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        );
      case '1 year':
        return Text(
          'M${12 - index}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        );
      default:
        return Text(
          '${index + 1}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        );
    }
  }
}