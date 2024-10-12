import 'package:flutter/material.dart';

class RecordsPage extends StatefulWidget {
  @override
  State<RecordsPage> createState() => RecordsPageState();
}

class RecordsPageState extends State<RecordsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body:  const Center(
        child: Text('Welcome this is Records Page!'),
      ),
    );
  }
}