import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import '../../backend/database_helper.dart';
import '../../Pages/theme_provider.dart';

class BalanceStatsPage extends StatefulWidget {
  const BalanceStatsPage({Key? key}) : super(key: key);

  @override
  _BalanceStatsPageState createState() => _BalanceStatsPageState();
}

class _BalanceStatsPageState extends State<BalanceStatsPage> {
  final List<String> _periods = ['Week', 'Month', '3 Months', '6 Months', 'Year'];
  int _selectedPeriodIndex = 0; // Default to Week
  List<FlSpot> _balanceData = [];
  double _currentBalance = 0.0;
  double _initialBalance = 0.0;
  double _percentageChange = 0.0;
  bool _isIncrease = true;

  @override
  void initState() {
    super.initState();
    _fetchBalanceData();
  }

  Future<void> _fetchBalanceData() async {
    final db = DatabaseHelper();
    final accounts = await db.getAccounts();
    final records = await db.getRecords();

    final today = DateTime.now();
    DateTime startDate;

    // Determine start date and group interval based on selected period
    switch (_selectedPeriodIndex) {
      case 0: // Week
        startDate = today.subtract(const Duration(days: 7));
        break;
      case 1: // Month
        startDate = today.subtract(const Duration(days: 30));
        break;
      case 2: // 3 Months
        startDate = today.subtract(const Duration(days: 84));
        break;
      case 3: // 6 Months
        startDate = today.subtract(const Duration(days: 180));
        break;
      case 4: // Year
        startDate = today.subtract(const Duration(days: 365));
        break;
      default:
        startDate = today.subtract(const Duration(days: 30));
    }

    // Calculate total initial balance
    double totalInitialBalance = 0;
    for (final account in accounts) {
      totalInitialBalance += account.balance;
    }

    // Group records by specified interval
    Map<DateTime, double> groupedBalances = {};
    double runningBalance = totalInitialBalance;

    // Determine grouping method based on selected period
    DateTime Function(DateTime) getGroupKey;
    switch (_selectedPeriodIndex) {
      case 0: // Week - group by day
        getGroupKey = (date) => DateTime(date.year, date.month, date.day);
        break;
      case 1: // Month - group by week
        getGroupKey = (date) => DateTime(date.year, date.month, (date.day - 1) ~/ 7 * 7 + 1);
        break;
      case 2: // 3 Months - group by week
        getGroupKey = (date) => DateTime(date.year, date.month, (date.day - 1) ~/ 7 * 7 + 1);
        break;
      case 3: // 6 Months - group by month
        getGroupKey = (date) => DateTime(date.year, date.month, 1);
        break;
      case 4: // Year - group by month
        getGroupKey = (date) => DateTime(date.year, date.month, 1);
        break;
      default:
        getGroupKey = (date) => DateTime(date.year, date.month, date.day);
    }

    // Filter records within the date range
    final filteredRecords = records.where((record) =>
    record.dateTime.isAfter(startDate) && record.dateTime.isBefore(today.add(const Duration(days: 1)))
    ).toList();

    // Sort records by date
    filteredRecords.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    // Calculate balance for each grouped interval
    for (var record in filteredRecords) {
      final groupKey = getGroupKey(record.dateTime);
      runningBalance -= record.amount;

      // Only update if this date is later than the previous record for this group
      if (!groupedBalances.containsKey(groupKey) || record.dateTime.isAfter(groupKey)) {
        groupedBalances[groupKey] = runningBalance;
      }
    }

    // Ensure we have an initial and final point
    if (!groupedBalances.containsKey(startDate)) {
      groupedBalances[startDate] = totalInitialBalance;
    }
    groupedBalances[today] = runningBalance;

    // Convert to FlSpots
    final spots = groupedBalances.entries
        .map((entry) => FlSpot(
      entry.key.difference(startDate).inDays.toDouble(),
      entry.value,
    ))
        .toList();

    spots.sort((a, b) => a.x.compareTo(b.x));

    // Calculate percentage change
    final initialBalance = spots.first.y;
    final currentTotalBalance = spots.last.y;
    final percentageChange = ((currentTotalBalance - initialBalance) / initialBalance) * 100;

    setState(() {
      _balanceData = spots;
      _currentBalance = currentTotalBalance;
      _initialBalance = initialBalance;
      _percentageChange = percentageChange.abs(); // Always positive
      _isIncrease = currentTotalBalance >= initialBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightColor = Provider.of<ThemeProvider>(context).lighterColor;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Statistics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Segmented Control
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppinioAnimatedToggleTab(
                  activeStyle: const TextStyle(color: Colors.white, fontSize: 15),
                  inactiveStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  tabTexts: _periods,
                  callback: (index) {
                    setState(() {
                      _selectedPeriodIndex = index;
                      _fetchBalanceData();
                    });
                  },
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  boxDecoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  animatedBoxDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.grey.withOpacity(0.08), width: 3),
                      vertical: BorderSide(color: Colors.grey.withOpacity(0.08), width: .8),
                    ),
                  ),
                  initialIndex: 0, // Default to Week
                ),
              ),

              const SizedBox(height: 20),

              // Current Balance and Percentage Change
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Balance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$${_currentBalance.toStringAsFixed(2)}',
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${_percentageChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isIncrease
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          Icon(
                            _isIncrease
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: _isIncrease
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Balance Graph
              _balanceData.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBalanceGraph(brightColor, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceGraph(Color brightColor, bool isDarkMode) {
    final minY = _balanceData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 200;
    final maxY = _balanceData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 100;

    return SizedBox(
      height: 400,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: _balanceData.last.x,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            verticalInterval: _getVerticalInterval(),
            horizontalInterval: (maxY - minY) / 5,
            getDrawingVerticalLine: (value) => FlLine(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (maxY - minY) / 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\$${value.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _getBottomTitleInterval(),
                getTitlesWidget: (value, meta) {
                  final startDate = DateTime.now().subtract(_getPeriodDuration());
                  final date = startDate.add(Duration(days: value.toInt()));
                  return Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      _formatBottomTitle(date),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                        fontSize: 10,
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
              spots: _balanceData,
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
                  final startDate = DateTime.now().subtract(_getPeriodDuration());
                  final date = startDate.add(Duration(days: spot.x.toInt()));
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
    );
  }

  // Helper method to get vertical interval based on selected period
  double _getVerticalInterval() {
    switch (_selectedPeriodIndex) {
      case 0: // Week
        return 1;
      case 1: // Month
        return 7;
      case 2: // 3 Months
        return 14;
      case 3: // 6 Months
        return 30;
      case 4: // Year
        return 60;
      default:
        return 7;
    }
  }

  // Helper method to get bottom title interval
  double _getBottomTitleInterval() {
    switch (_selectedPeriodIndex) {
      case 0: // Week
        return 1;
      case 1: // Month
        return 7;
      case 2: // 3 Months
        return 14;
      case 3: // 6 Months
        return 30;
      case 4: // Year
        return 60;
      default:
        return 7;
    }
  }

  // Helper method to format bottom title based on selected period
  String _formatBottomTitle(DateTime date) {
    switch (_selectedPeriodIndex) {
      case 0: // Week
        return DateFormat('EEE').format(date);
      case 1: // Month
        return DateFormat('d MMM').format(date);
      case 2: // 3 Months
      case 3: // 6 Months
      case 4: // Year
        return DateFormat('MMM').format(date);
      default:
        return DateFormat('d MMM').format(date);
    }
  }

  // Helper method to get period duration based on selected period
  Duration _getPeriodDuration() {
    switch (_selectedPeriodIndex) {
      case 0: // Week
        return const Duration(days: 7);
      case 1: // Month
        return const Duration(days: 30);
      case 2: // 3 Months
        return const Duration(days: 84);
      case 3: // 6 Months
        return const Duration(days: 180);
      case 4: // Year
        return const Duration(days: 365);
      default:
        return const Duration(days: 30);
    }
  }
}