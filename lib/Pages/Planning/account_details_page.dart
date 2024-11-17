import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:intl/intl.dart';
import '../../backend/Categories.dart';
import '../../backend/accounts.dart';
import '../../backend/records.dart';
import '../../backend/database_helper.dart';

class AccountDetailsPage extends StatefulWidget {
  final Account account;

  const AccountDetailsPage({super.key, required this.account});

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  String selectedTimeFilter = 'Month';
  late List<Record> accountRecords = [];
  double selectedValue = 0;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedTimeFilter = 'Week'; // Set the default filter to 'Week'
    _loadAccountRecords();
  }

  Future<void> _loadAccountRecords() async {
    final state = Provider.of<FinanceState>(context, listen: false);
    accountRecords = (await state.getRecords())
        .where((record) => record.accountName == widget.account.name)
        .toList();
    setState(() {});
  }

  List<FlSpot> _getChartData() {
    if (accountRecords.isEmpty) return [const FlSpot(0, 0)];

    Map<DateTime, double> dailyTotals = {};
    double runningBalance = widget.account.balance;

    // Sort records by date in descending order
    accountRecords.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    // Calculate running balance for each day
    for (var record in accountRecords) {
      DateTime date = DateTime(record.dateTime.year, record.dateTime.month, record.dateTime.day);
      dailyTotals[date] = runningBalance;
      runningBalance -= record.amount;
    }

    // Convert to list of spots
    List<FlSpot> spots = dailyTotals.entries.map((entry) {
      return FlSpot(
        entry.key.millisecondsSinceEpoch.toDouble(),
        entry.value,
      );
    }).toList();

    return spots.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.account.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildTimeFilter(),
            _buildChart(),
            _buildTransactionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AppinioAnimatedToggleTab(
        activeStyle: const TextStyle(color: Colors.white, fontSize: 15),
        inactiveStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        tabTexts: const ['Day', 'Week', 'Month'],
        callback: (index) {
          setState(() {
            selectedTimeFilter = ['Day', 'Week', 'Month'][index];
          });
        },
        height: 50,
        width: MediaQuery.of(context).size.width * 0.85,
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
        initialIndex: 1, // Default to 'Week'
      ),
    );
  }

  List<FlSpot> _calculateSpots() {
    if (accountRecords.isEmpty) {
      int points = numberOfPoints();
      return List.generate(points, (i) => FlSpot(i.toDouble(), widget.account.balance));
    }

    accountRecords.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    DateTime endDate = DateTime.now();
    DateTime startDate;

    switch (selectedTimeFilter) {
      case 'Month':
        startDate = DateTime(endDate.year, endDate.month - 5, 1);
        break;
      case 'Week':
        startDate = endDate.subtract(const Duration(days: 42));
        break;
      default: // Day
        startDate = endDate.subtract(const Duration(days: 30));
    }

    Map<DateTime, double> dailyBalances = {};
    double runningBalance = 0; // Start from 0 and build up to current balance

    // Get the earliest relevant date
    var relevantRecords = accountRecords.where((record) =>
    !record.dateTime.isBefore(startDate) &&
        !record.dateTime.isAfter(endDate)
    ).toList();

    // Add all transactions to get to current balance
    for (var record in relevantRecords) {
      runningBalance += record.amount; // Add the amount (negative amounts will subtract)
    }

    // Current balance minus all transactions equals starting balance
    double startingBalance = widget.account.balance - runningBalance;
    runningBalance = startingBalance;

    // Add today's balance
    DateTime today = DateTime(endDate.year, endDate.month,
        selectedTimeFilter == 'Month' ? 1 : endDate.day);
    dailyBalances[today] = widget.account.balance;

    // Calculate running balance for each day
    for (var record in relevantRecords) {
      DateTime recordDate = DateTime(
          record.dateTime.year,
          record.dateTime.month,
          selectedTimeFilter == 'Month' ? 1 : record.dateTime.day
      );

      runningBalance += record.amount;
      dailyBalances[recordDate] = runningBalance;
    }

    // Generate spots for the graph
    List<FlSpot> spots = [];
    int points = numberOfPoints();

    for (int i = 0; i < points; i++) {
      DateTime currentDate;
      switch (selectedTimeFilter) {
        case 'Month':
          currentDate = DateTime(endDate.year, endDate.month - (points - 1 - i), 1);
          break;
        case 'Week':
          currentDate = startDate.add(Duration(days: i));
          break;
        default:
          currentDate = startDate.add(Duration(days: i));
      }

      double balance;
      if (dailyBalances.isEmpty) {
        balance = widget.account.balance;
      } else {
        var availableDates = dailyBalances.keys
            .where((date) => !date.isAfter(currentDate))
            .toList();
        if (availableDates.isEmpty) {
          balance = startingBalance;
        } else {
          availableDates.sort((a, b) => b.compareTo(a)); // Sort in descending order
          balance = dailyBalances[availableDates.first]!;
        }
      }

      spots.add(FlSpot(i.toDouble(), balance));
    }

    // Ensure the last point shows current balance
    if (spots.isNotEmpty) {
      spots[spots.length - 1] = FlSpot(spots.last.x, widget.account.balance);
    }

    return spots;
  }

  int numberOfPoints() {
    switch (selectedTimeFilter) {
      case 'Month':
        return 6; // 6 months
      case 'Week':
        return 42; // 6 weeks
      default: // Day
        return 30; // 30 days
    }
  }

  Widget _buildChart() {
    final spots = _calculateSpots();
    final minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 200;
    final maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 100;

    return Container(
      height: 250,
      padding: const EdgeInsets.only(left:8,right: 16, bottom:6,top: 10),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (numberOfPoints() - 1).toDouble(),
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
                reservedSize: 25,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  switch (selectedTimeFilter) {
                    case 'Month':
                      final date = _getDateForValue(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('MMM').format(date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      );
                    case 'Week':
                      if (value % 7 != 0) return const Text('');
                      final date = _getDateForValue(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'W${((date.day + date.weekday) ~/ 7) + 1}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      );
                    default: // Day
                      if (value % 5 != 0) return const Text('');
                      final date = _getDateForValue(value.toInt());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: widget.account.color,
              barWidth: 2.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: widget.account.color.withOpacity(0.1),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.account.color.withOpacity(0.15),
                    widget.account.color.withOpacity(0.05),
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
              tooltipBorder: BorderSide(
                color: widget.account.color.withOpacity(0.2),
                width: 1,
              ),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final date = _getDateForValue(spot.x.toInt());
                  return LineTooltipItem(
                    '${_formatTooltipDate(date)}\n${widget.account.currency} ${spot.y.toStringAsFixed(2)}',
                    TextStyle(
                      color: widget.account.color,
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

  DateTime _getDateForValue(int value) {
    final now = DateTime.now();
    switch (selectedTimeFilter) {
      case 'Month':
        return DateTime(now.year, now.month - (5 - value), 1);
      case 'Week':
        return now.subtract(Duration(days: 42 - value));
      default: // Day
        return now.subtract(Duration(days: 30 - value));
    }
  }

  String _formatTooltipDate(DateTime date) {
    switch (selectedTimeFilter) {
      case 'Month':
        return DateFormat('MMMM yyyy').format(date);
      case 'Week':
        return '${DateFormat('MMM d').format(date)} - ${DateFormat('MMM d').format(date.add(const Duration(days: 6)))}';
      default: // Day
        return DateFormat('MMM d').format(date);
    }
  }

  Widget _buildTransactionsList() {
    accountRecords.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Time",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 5),
                Icon(Icons.sort, color: Colors.grey[800]),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                child: Text(
                  'Records',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: accountRecords.length,
                itemBuilder: (context, index) {
                  final record = accountRecords[index];
                  final category = categories[record.categoryId];
                  final now = DateTime.now();
                  final isSameYear = record.dateTime.year == now.year;
                  final dateFormat = isSameYear ? DateFormat('MMM dd, HH:mm') : DateFormat('yyyy-MM-dd HH:mm');
                  final formattedDate = dateFormat.format(record.dateTime);

                  return Dismissible(
                    key: Key(record.id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      await Provider.of<FinanceState>(context, listen: false).deleteRecord(record.id);
                      setState(() {
                        accountRecords.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Record deleted')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: category.color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconTheme(
                              data: const IconThemeData(color: Colors.white),
                              child: category.icon,
                            ),
                          ),
                          title: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            formattedDate,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            '${record.amount > 0 ? '+ \$' : ''}${record.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: record.amount > 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(thickness: 0.2, height: 1),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}