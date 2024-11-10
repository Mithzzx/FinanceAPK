import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/budgets.dart';
import '../../backend/records.dart';
import '../../backend/database_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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

    final totalSpent = _relevantRecords.fold(0.0, (sum, record) => sum + record.amount);
    final daysInPeriod = _getDaysInPeriod();
    final daysElapsed = _getDaysElapsed();

    _dailyAverage = totalSpent / daysElapsed;
    _dailyRecommended = (widget.budget.totalAmount - totalSpent) / (daysInPeriod - daysElapsed);
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

  void _generateTrendData() {
    final spendingByDay = <DateTime, double>{};

    for (var record in _relevantRecords) {
      final date = DateTime(record.dateTime.year, record.dateTime.month, record.dateTime.day);
      spendingByDay[date] = (spendingByDay[date] ?? 0) + record.amount;
    }

    _spendingTrend = spendingByDay.entries
        .map((e) => FlSpot(
      e.key.millisecondsSinceEpoch.toDouble(),
      e.value,
    ))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
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
              // TODO: Implement edit functionality
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

  Widget _buildTrendGraph() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trend'),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          return Text(DateFormat('MM/dd').format(date));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _spendingTrend,
                      isCurved: true,
                      color: Colors.green,
                      dotData: const FlDotData(show: true),
                    ),
                    // Budget line
                    LineChartBarData(
                      spots: [
                        FlSpot(DateTime.now().subtract(const Duration(days: 7))
                            .millisecondsSinceEpoch.toDouble(), widget.budget.totalAmount),
                        FlSpot(DateTime.now().millisecondsSinceEpoch.toDouble(),
                            widget.budget.totalAmount),
                      ],
                      color: Colors.white,
                      dotData: const FlDotData(show: false),
                      dashArray: [5, 5],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Budget', Colors.white),
                  const SizedBox(width: 16),
                  _buildLegendItem('Spent', Colors.green),
                  const SizedBox(width: 16),
                  _buildLegendItem('Forecast spent', Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        return ListTile(
          title: Text('₹${record.amount.toStringAsFixed(2)}'),
          subtitle: Text(DateFormat('MMM dd, yyyy').format(record.dateTime)),
          trailing: Text(record.paymentType),
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