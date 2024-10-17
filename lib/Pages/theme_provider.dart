import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  Brightness systemBrightness = Brightness.light;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners(); // Notifies widgets about theme change
  }

  // List of themes
  static final List<ThemeData> themes = [
    ThemeData.light(), // Light theme
    ThemeData(
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.dark// Green theme
    ),  // Dark theme
    ThemeData(
      colorSchemeSeed: Colors.green,
        brightness: Brightness.dark// Green theme
    ),
    ThemeData(
      colorSchemeSeed: Colors.red,
        brightness: Brightness.dark// Blue theme
    ),
    ThemeData(
      colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark// Red theme
    ),
  ];
}
