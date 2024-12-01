import 'package:finance_apk/backend/Categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/budgets.dart';
import '../../backend/records.dart';
import '../../backend/database_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'budgets_edit.dart';

class BudgetViewPage extends StatefulWidget {
  final Budget budget;

  const BudgetViewPage({super.key, required this.budget});

  @override
  State<BudgetViewPage> createState() => _BudgetViewPageState();
}

class _BudgetViewPageState extends State<BudgetViewPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Record> _relevantRecords = [];
  double _dailyAverage = 0;
  double _dailyRecommended = 0;
  List<FlSpot> _spendingTrend = [];
  List<FlSpot> _forecastTrend = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final financeState = context.read<FinanceState>();
    final allRecords = await financeState.getRecords();

    setState(() {
      _relevantRecords = _filterRecordsForPeriod(allRecords);
      _calculateMetrics();
      _generateTrendData();
    });
  }

  List<Record> _filterRecordsForPeriod(List<Record> records) {
    final now = DateTime.now();
    return records.where((record) {
      if (!widget.budget.categoryIds.contains(record.categoryId)) return false;
      if (widget.budget.accountName != record.accountName) return false;

      switch (widget.budget.period) {
        case 'weekly':
          return record.dateTime.isAfter(now.subtract(const Duration(days: 7)));
        case 'monthly':
          return record.dateTime.year == now.year &&
              record.dateTime.month == now.month;
        case 'yearly':
          return record.dateTime.year == now.year;
        case 'onetime':
          return true;
        default:
          return false;
      }
    }).toList();
  }

  void _calculateMetrics() {
    if (_relevantRecords.isEmpty) return;

    final totalSpent = _relevantRecords.fold(0.0, (sum, record) => sum - record.amount);
    final daysElapsed = _getDaysElapsed();

    _dailyAverage = totalSpent / daysElapsed;
    _dailyRecommended = (widget.budget.totalAmount - totalSpent) / (_getDaysInPeriod() - daysElapsed+1);
  }

  int _getDaysInPeriod() {
    switch (widget.budget.period) {
      case 'weekly':
        return 7;
      case 'monthly':
        return DateTime.now().month == 2 ? 28 : 30;
      case 'yearly':
        return 365;
      default:
        return 1;
    }
  }

  int _getDaysElapsed() {
    final now = DateTime.now();
    switch (widget.budget.period) {
      case 'weekly':
        return now.weekday;
      case 'monthly':
        return now.day;
      case 'yearly':
        return now.difference(DateTime(now.year, 1, 1)).inDays;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final remainingPercentage = ((widget.budget.totalAmount - widget.budget.spentAmount) /
        widget.budget.totalAmount * 100).clamp(0, 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budget.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBudgetPage(budget: widget.budget)
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Records'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(remainingPercentage /1),
                _buildRecordsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(double remainingPercentage) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPeriodSection(),
        _buildAmountSection(remainingPercentage),
        _buildTrendGraph(),
        _buildDailyMetrics(),
        _buildLastPeriodsSection(),
      ],
    );
  }

  Widget _buildPeriodSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.budget.period.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${widget.budget.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${((widget.budget.totalAmount - widget.budget.spentAmount) /
                        widget.budget.totalAmount * 100).toStringAsFixed(1)}% left',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                minHeight: 18,
                value: widget.budget.spentAmount / widget.budget.totalAmount,
                backgroundColor: Colors.grey[850],
                valueColor: AlwaysStoppedAnimation(
                  widget.budget.spentAmount >= widget.budget.totalAmount ? Colors.red :
                  widget.budget.spentAmount / widget.budget.totalAmount >= 0.75 ? Colors.orange :
                  Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection(double remainingPercentage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildAmountColumn('Spent', widget.budget.spentAmount),
            _buildAmountColumn('Planned', widget.budget.totalAmount),
            _buildAmountColumn(
              'Remains',
              widget.budget.totalAmount - widget.budget.spentAmount,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountColumn(String label, double amount) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  void _generateTrendData() {
    if (_relevantRecords.isEmpty) {
      _spendingTrend = List.generate(7, (index) => FlSpot(index.toDouble(), 0.0));
      return;
    }

    final spendingByDay = <DateTime, double>{};

    // Group records by day and sum their amounts
    for (var record in _relevantRecords) {
      final dayKey = DateTime(record.dateTime.year, record.dateTime.month, record.dateTime.day);
      spendingByDay[dayKey] = (spendingByDay[dayKey] ?? 0) + record.amount;
    }

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday));

    // Generate cumulative spending trend
    _spendingTrend = List.generate(7, (index) {
      final currentDay = startOfWeek.add(Duration(days: index));
      final dayKey = DateTime(currentDay.year, currentDay.month, currentDay.day);

      // Calculate cumulative spending up to and including this day
      final cumulativeSpending = spendingByDay.entries
          .where((entry) =>
          entry.key.isBefore(dayKey.add(const Duration(days: 1))))
          .fold(0.0, (sum, entry) => sum - entry.value);

      return FlSpot(index.toDouble(), cumulativeSpending);
    });
  }

  Widget _buildTrendGraph() {
    if (_spendingTrend.isEmpty) {
      return const Card(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    const brightColor = Colors.green;
    const minY = 0.0;
    final maxY = widget.budget.totalAmount * 1.1;

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SPENDING TREND',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 16),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: _getPeriodMaxX(),
                  minY: minY,
                  maxY: maxY,
                  gridData: const FlGridData(show: false),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (spot) => Theme.of(context).colorScheme.primaryContainer,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final date = _getDateFromSpotIndex(spot.x);
                          return LineTooltipItem(
                            '${DateFormat('MMM d').format(date)}\n₹${spot.y.toStringAsFixed(2)}',
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
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: widget.budget.totalAmount / 4,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${value.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                              fontSize: 8,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _getBottomTitleWidget,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: widget.budget.totalAmount,
                        color: Colors.white.withOpacity(0.3),
                        dashArray: [5, 5],
                        strokeWidth: 1,
                      ),
                    ],
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _spendingTrend,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBottomTitleWidget(double value, TitleMeta meta) {
    final date = _getDateFromSpotIndex(value);

    switch (widget.budget.period) {
      case 'weekly':
        final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        if (value >= 0 && value < 7) {
          return Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              weekDays[value.toInt()],
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          );
        }
        return const Text('');

      case 'monthly':
        if (value % 6 == 0) {
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
        }
        return const Text('');

      case 'yearly':
        return Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            DateFormat('MMM').format(date),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        );

      default:
        return const Text('');
    }
  }

  DateTime _getDateFromSpotIndex(double index) {
    final now = DateTime.now();

    switch (widget.budget.period) {
      case 'weekly':
        return now.subtract(Duration(days: now.weekday - 1 - index.toInt()));

      case 'monthly':
        return DateTime(now.year, now.month, index.toInt() + 1);

      case 'yearly':
        return DateTime(now.year, index.toInt() + 1, 15);

      default:
        return now;
    }
  }

  double _getPeriodMaxX() {
    switch (widget.budget.period) {
      case 'weekly':
        return 6; // 7 days (0-6)

      case 'monthly':
        return DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day.toDouble();

      case 'yearly':
        return 11; // 12 months (0-11)

      default:
        return 1;
    }
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildDailyMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daily Average'),
                Text(
                  '₹${_dailyAverage.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Daily Recommended'),
                Text(
                  '₹${_dailyRecommended.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastPeriodsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Last 6 periods'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement period selection
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('This week'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsTab() {
  return ListView.builder(
    itemCount: _relevantRecords.length,
    itemBuilder: (context, index) {
      final record = _relevantRecords[index];
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categories[record.categoryId].color,
              borderRadius: BorderRadius.circular(8.0), // Curved edges
            ),
            child: Center(
              child: Center(
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white),
                  child: categories[record.categoryId].icon,
                ),
              ),
            ),
          ),
          title: Text('₹${record.amount.toStringAsFixed(2)}'),
          subtitle: Text(DateFormat('MMM dd, yyyy').format(record.dateTime)),
          trailing: Text(record.paymentType),
        ),
      );
    },
  );
}

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}