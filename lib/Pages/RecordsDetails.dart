import 'package:flutter/material.dart';
import '../backend/database_helper.dart';
import '../backend/records.dart';

class RecordDetailsPage extends StatefulWidget {
  final Record record;

  const RecordDetailsPage({super.key, required this.record});

  @override
  _RecordDetailsPageState createState() => _RecordDetailsPageState();
}

class _RecordDetailsPageState extends State<RecordDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}