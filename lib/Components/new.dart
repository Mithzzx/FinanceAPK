import 'package:flutter/material.dart';

class ThemeChangerPage extends StatefulWidget {
  @override
  _ThemeChangerPageState createState() => _ThemeChangerPageState();
}

class _ThemeChangerPageState extends State<ThemeChangerPage> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: Text('Theme Changer')),
        body: Center(
          child: ElevatedButton(
            child: Text('Toggle Theme'),
            onPressed: () {
              setState(() {
                _isDarkTheme = !_isDarkTheme;
              });
            },
          ),
        ),
      ),
    );
  }
}