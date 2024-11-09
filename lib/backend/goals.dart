// lib/backend/goal.dart
import 'package:flutter/material.dart';

class Goal {
  final int? id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadlineDate;
  final Color color;
  final Icon icon;
  final String? notes;

  Goal({
    this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadlineDate,
    required this.color,
    required this.icon,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadlineDate': deadlineDate.toIso8601String(),
      'color': color.value,
      'icon': icon.icon!.codePoint,
      'notes': notes,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'],
      name: map['name'],
      targetAmount: map['targetAmount'],
      savedAmount: map['savedAmount'],
      deadlineDate: DateTime.parse(map['deadlineDate']),
      color: Color(map['color']),
      icon: Icon(IconData(map['icon'], fontFamily: 'MaterialIcons')),
      notes: map['notes'],
    );
  }
}