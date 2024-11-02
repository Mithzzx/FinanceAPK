import 'package:flutter/material.dart';

class DateTimeCard extends StatefulWidget {
  final Function(DateTime?) onDateTimeChanged;

  DateTimeCard({required this.onDateTimeChanged});

  @override
  _DateTimeCardState createState() => _DateTimeCardState();
}

class _DateTimeCardState extends State<DateTimeCard> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now(); // Initialize with the current date and time
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
          selectedDateTime = DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
            selectedTime!.hour,
            selectedTime!.minute,
          );
          widget.onDateTimeChanged(selectedDateTime);
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return "${date.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateTime(context),
      child: Card(
        color: (selectedDate != null && selectedTime != null)
            ? Theme.of(context).colorScheme.primary
            : null,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (selectedDate == null) ...[
                Icon(
                  Icons.calendar_today,
                  size: 25,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 10),
              ],
              if (selectedDate != null && selectedTime != null) ...[
                Text(
                  _formatDate(selectedDate!),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  selectedTime!.format(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                const Text(
                  'Date & Time',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}