import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  @override
  State<StatsPage> createState() => StatsPageState();
}

class StatsPageState extends State<StatsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: const Center(
        child: Text('Welcome this is Stats Page!'),
      ),
    );
  }
}