import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../backend/database_helper.dart';
import '../../backend/goals.dart';

class AddGoalPage extends StatefulWidget {
  final Goal? goalToEdit;
  const AddGoalPage({super.key, this.goalToEdit});

  @override
  _AddGoalPageState createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  Color _selectedColor = Colors.blue;
  Icon _selectedIcon = const Icon(Icons.star);

  @override
  void initState() {
    super.initState();
    if (widget.goalToEdit != null) {
      _nameController.text = widget.goalToEdit!.name;
      _targetAmountController.text = widget.goalToEdit!.targetAmount.toString();
      _notesController.text = widget.goalToEdit!.notes ?? '';
      _selectedDate = widget.goalToEdit!.deadlineDate;
      _selectedColor = widget.goalToEdit!.color;
      _selectedIcon = widget.goalToEdit!.icon;
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Goal'),
          content: const Text('Are you sure you want to delete this goal? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                // Delete the goal
                Provider.of<FinanceState>(context, listen: false)
                    .deleteGoal(widget.goalToEdit!.id!);
                // Pop the delete confirmation dialog
                Navigator.pop(context);
                // Pop the edit page
                Navigator.pop(context);
                // Pop the goal view page if it exists
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  _pickColor() async {
    final Color? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop(_selectedColor);
              },
            ),
          ],
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedColor = picked;
      });
    }
  }

  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
        context,
        configuration: const SinglePickerConfiguration(
          iconPackModes: [IconPack.fontAwesomeIcons],
        ));


    if (icon != null) {
      setState(() {
        _selectedIcon = Icon(icon.data);
      });
    }
  }

  _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final goal = Goal(
        id: widget.goalToEdit?.id,
        name: _nameController.text,
        targetAmount: double.parse(_targetAmountController.text),
        savedAmount: widget.goalToEdit?.savedAmount ?? 0,
        deadlineDate: _selectedDate,
        color: _selectedColor,
        icon: _selectedIcon,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      final financeState = Provider.of<FinanceState>(context, listen: false);
      if (widget.goalToEdit != null) {
        financeState.updateGoal(goal);
      } else {
        financeState.addGoal(goal);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goalToEdit != null ? 'Edit Goal' : 'Add New Goal'),
        actions: [
          if (widget.goalToEdit != null)
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetAmountController,
                decoration: const InputDecoration(
                  labelText: 'Target Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        'Deadline: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                      ),
                      onPressed: _pickDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.color_lens, color: _selectedColor),
                      label: const Text('Pick Color'),
                      onPressed: _pickColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: _selectedIcon,
                      label: const Text('Pick Icon'),
                      onPressed: _pickIcon,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveGoal,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(widget.goalToEdit != null ? 'Update Goal' : 'Save Goal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}