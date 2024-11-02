import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
import '../backend/Records.dart';

class RecordDetailsPage extends StatefulWidget {
  final Record record;

  const RecordDetailsPage({super.key, required this.record});

  @override
  _RecordDetailsPageState createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late TextEditingController _payeeController;
  late TextEditingController _paymentTypeController;
  late TextEditingController _warrantyController;
  late TextEditingController _statusController;
  late TextEditingController _locationController;
  late TextEditingController _photoController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.record.amount.toString());
    _notesController = TextEditingController(text: widget.record.notes);
    _payeeController = TextEditingController(text: widget.record.payee);
    _paymentTypeController = TextEditingController(text: widget.record.paymentType);
    _warrantyController = TextEditingController(text: widget.record.warranty);
    _statusController = TextEditingController(text: widget.record.status);
    _locationController = TextEditingController(text: widget.record.location);
    _photoController = TextEditingController(text: widget.record.photo);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _payeeController.dispose();
    _paymentTypeController.dispose();
    _warrantyController.dispose();
    _statusController.dispose();
    _locationController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  Future<void> _saveRecord() async {
    widget.record.amount = double.parse(_amountController.text);
    widget.record.notes = _notesController.text;
    widget.record.payee = _payeeController.text;
    widget.record.paymentType = _paymentTypeController.text;
    widget.record.warranty = _warrantyController.text;
    widget.record.status = _statusController.text;
    widget.record.location = _locationController.text;
    widget.record.photo = _photoController.text;

    await DatabaseHelper().updateRecord(widget.record);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRecord,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            TextField(
              controller: _payeeController,
              decoration: const InputDecoration(labelText: 'Payee'),
            ),
            TextField(
              controller: _paymentTypeController,
              decoration: const InputDecoration(labelText: 'Payment Type'),
            ),
            TextField(
              controller: _warrantyController,
              decoration: const InputDecoration(labelText: 'Warranty'),
            ),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _photoController,
              decoration: const InputDecoration(labelText: 'Photo'),
            ),
          ],
        ),
      ),
    );
  }
}