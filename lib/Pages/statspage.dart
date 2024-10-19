import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  @override
  State<StatsPage> createState() => StatsPageState();
}

class StatsPageState extends State<StatsPage> {
  final List<String> texts = [
    'BALANCE',
    'SPENDING',
    'CASH FLOW',
    'OUTLOOK',
    'CREDIT',
    'REPORTS - INCOME',
  ];

  final List<String> subtitles = [
    '₹ 32,000.54',
    '₹ 12,000.00',
    '₹ 20,000.54',
    'POSITIVE',
    '₹ 5,000.00',
    '₹ 10,000.00',
  ];

  final List<IconData> icons = [
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.accessibility,
    Icons.account_balance,
    Icons.adb,
    Icons.add_a_photo,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
        child: ListView.builder(
          itemCount: texts.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1.3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          texts[index],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          subtitles[index],
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icons[index],
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}