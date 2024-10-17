import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  Brightness brightness = Brightness.dark;
  bool isDarkMode = true;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  bool isDarkMod() {
    return isDarkMode;
  }

  void setTempTheme(Color colorSchemeSeed) {
    _themeData = ThemeData(
      colorSchemeSeed: colorSchemeSeed,
      brightness: brightness,
    );
    notifyListeners(); // Notifies widgets about theme change
  }
  void setTheme(Color colorSchemeSeed) {
    _themeData = ThemeData(
      colorSchemeSeed: colorSchemeSeed,
      brightness: brightness,
    );
    currentTheme = _themeData;
    notifyListeners(); // Notifies widgets about theme change
  }

  void toggleBrightness() {
    brightness = brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    isDarkMode = !isDarkMode;
    setTempTheme(currentTheme.primaryColor);
     // Notifies widgets about theme change
  }

  static ThemeData currentTheme = ThemeData(
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
  );
  // List of themes
  static final List<Color> themes = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
  ];
}