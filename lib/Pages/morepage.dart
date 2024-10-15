import 'package:flutter/material.dart';

class MorePage extends StatefulWidget {
  @override
  State<MorePage> createState() => MorePageState();
}

class MorePageState extends State<MorePage> {

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