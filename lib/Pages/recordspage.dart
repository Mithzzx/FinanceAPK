import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../backend/database_helper.dart';
import '../backend/records.dart';
import '../backend/Categories.dart';
import 'RecordsDetails.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      setState(() => _isLoading = true);
      await Provider.of<FinanceState>(context, listen: false).loadData();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

Widget _buildRecordsList(List<Record> records) {
  records.sort((a, b) => b.dateTime.compareTo(a.dateTime));

  // Group records by day
  Map<String, List<Record>> groupedRecords = {};
  for (var record in records) {
    String dateKey = DateFormat('yyyy-MM-dd').format(record.dateTime);
    groupedRecords.putIfAbsent(dateKey, () => []).add(record);
  }

  return RefreshIndicator(
    onRefresh: _loadRecords,
    child: ListView.builder(
      itemCount: groupedRecords.length,
      itemBuilder: (context, index) {
        String dateKey = groupedRecords.keys.elementAt(index);
        List<Record> dayRecords = groupedRecords[dateKey]!;
        DateTime date = DateTime.parse(dateKey);

        String formattedDate = DateFormat('dd MMM').format(date).toUpperCase();
        if (date.year != DateTime.now().year) {
          formattedDate += ' ${date.year}';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 4), // Add space between days
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 0),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            ...dayRecords.map((record) => Column(
              children: [
                _buildRecordTile(record),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(thickness: 0.3,height: 4,),
                ), // Add divider between tiles
              ],
            )),
          ],
        );
      },
    ),
  );
}

  Widget _buildRecordTile(Record record) {
    final category = categories[record.categoryId];
    final amountText = record.amount < 0
        ? '-\$${record.amount.abs().toStringAsFixed(2)}'
        : '+\$${record.amount.toStringAsFixed(2)}';
    final amountColor = record.amount < 0 ? Colors.red : Colors.green;

    return Dismissible(
      key: Key(record.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        if (record.id != null) {
          await Provider.of<FinanceState>(context, listen: false).deleteRecord(record.id!);
          setState(() {
            Provider.of<FinanceState>(context, listen: false).records.remove(record);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Record deleted')),
          );
        }
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              record.accountName,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amountText,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: amountColor),
            ),
            Text(
              '${record.dateTime.hour.toString().padLeft(2, '0')}:${record.dateTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordDetailsPage(record: record),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Records'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadRecords,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : Consumer<FinanceState>(
        builder: (context, financeState, child) {
          return _buildRecordsList(financeState.records);
        },
      ),
    );
  }
}