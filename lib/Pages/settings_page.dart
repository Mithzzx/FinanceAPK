import 'package:finance_apk/Pages/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}
class colorIndex {
  final Color c;
  final int index;

  colorIndex({required this.c, required this.index});
}
class _SettingsPageState extends State<SettingsPage> {
  Color selectedColor = Colors.blue;

  final List<colorIndex> colors = [
    colorIndex(c: Colors.red, index: 0),
    colorIndex(c: Colors.green, index: 1),
    colorIndex(c: Colors.blue, index: 2),
    colorIndex(c: Colors.orange, index: 3),
    colorIndex(c: Colors.purple, index: 4),
    colorIndex(c: Colors.yellow, index: 5),
    colorIndex(c: Colors.cyan, index: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'App Color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: colors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color.c;
                          Provider.of<ThemeProvider>(context, listen: false).setTheme(
                              ThemeProvider.themes[color.index]);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(),
            SwitchListTile(
              title: Text('Dark Mode', style: Theme.of(context).textTheme.titleMedium),
              value: !Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  Provider.of<ThemeProvider>(context, listen: false).toggleBrightness();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}