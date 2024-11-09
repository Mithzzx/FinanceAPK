import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../backend/database_helper.dart';
import '../../backend/goals.dart';
import 'icon_picker.dart';

class AddGoalPage extends StatefulWidget {
  @override
  _AddGoalPageState createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _savedAmountController = TextEditingController();
  final _deadlineDateController = TextEditingController();
  final _notesController = TextEditingController();
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.star;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _targetAmountController,
                decoration: const InputDecoration(labelText: 'Target Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _savedAmountController,
                decoration: const InputDecoration(labelText: 'Saved Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a saved amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deadlineDateController,
                decoration: const InputDecoration(labelText: 'Deadline Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a deadline date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color:'),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      Color? pickedColor = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: _selectedColor,
                              onColorChanged: (color) {
                                setState(() {
                                  _selectedColor = color;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      );
                      if (pickedColor != null) {
                        setState(() {
                          _selectedColor = pickedColor;
                        });
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      color: _selectedColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Icon:'),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(_selectedIcon),
                    onPressed: () async {
                      IconData? pickedIcon = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: SingleChildScrollView(
                            child: IconPicker(
                              icon: _selectedIcon,
                              onIconChanged: (icon) {
                                setState(() {
                                  _selectedIcon = icon;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      );
                      if (pickedIcon != null) {
                        setState(() {
                          _selectedIcon = pickedIcon;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Goal newGoal = Goal(
                      name: _nameController.text,
                      targetAmount: double.parse(_targetAmountController.text),
                      savedAmount: double.parse(_savedAmountController.text),
                      deadlineDate: DateTime.parse(_deadlineDateController.text),
                      color: _selectedColor,
                      icon: Icon(_selectedIcon),
                      notes: _notesController.text,
                    );
                    Provider.of<FinanceState>(context, listen: false).addGoal(newGoal);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}