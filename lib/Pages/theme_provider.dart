// lib/Pages/theme_provider.dart
import 'package:flutter/material.dart';

class MyTheme {
  ThemeData themeData;
  Color color;
  MyTheme({required this.themeData, required this.color});
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  Brightness brightness = Brightness.dark;
  bool isDarkMode = true;
  Color _lighterColor; // Private variable to store the lighter color

  ThemeProvider(this._themeData) : _lighterColor = const Color.fromARGB(255, 119, 179, 240); // Initialize _lighterColor

  ThemeData get themeData => _themeData;

  bool isDarkMod() {
    return isDarkMode;
  }

  Color get lighterColor => _lighterColor; // Getter method to access the lighter color

  Color getLighterColor(Color color, [double amount = 0.3]) {
    assert(amount >= 0 && amount <= 1);
    return Color.lerp(color, Colors.white, amount)!;
  }

  void setTheme(Color colorSchemeSeed) {
    _lighterColor = getLighterColor(colorSchemeSeed); // Update _lighterColor
    _themeData = ThemeData(
      colorSchemeSeed: colorSchemeSeed,
      brightness: brightness,
      canvasColor: brightness == Brightness.dark ? Colors.black : null,
      scaffoldBackgroundColor: brightness == Brightness.dark ? Colors.black : null,
      cardTheme: CardTheme(
        color: brightness == Brightness.dark ? const Color.fromARGB(255, 25, 25, 25) : null,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brightness == Brightness.dark ? _lighterColor : null, // Use lighter color
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.dark ? Colors.black : colorSchemeSeed, // Fixed color
      ),
    );
    currentTheme.themeData = _themeData;
    currentTheme.color = colorSchemeSeed;
    print("currentTheme: " + currentTheme.color.toString());
    notifyListeners(); // Notifies widgets about theme change
  }

  void setTempTheme(Color colorSchemeSeed) {
    _lighterColor = getLighterColor(colorSchemeSeed); // Update _lighterColor
    _themeData = ThemeData(
      colorSchemeSeed: colorSchemeSeed,
      brightness: brightness,
      canvasColor: brightness == Brightness.dark ? Colors.black : null,
      cardTheme: CardTheme(
        color: brightness == Brightness.dark ? const Color.fromARGB(255, 25, 25, 25) : null,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lighterColor, // Use lighter color
        ),
      ),
    );
    notifyListeners(); // Notifies widgets about theme change
  }

  void toggleBrightness() {
    brightness = brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    isDarkMode = !isDarkMode;
    setTheme(currentTheme.color);
    // Notifies widgets about theme change
  }

  static MyTheme currentTheme = MyTheme(
    themeData: ThemeData(
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.dark,
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      cardTheme: const CardTheme(
        color: Color.fromARGB(255, 25, 25, 25),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color.lerp(Colors.blue, Colors.white, 0.2), // Use lighter color
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black, // Fixed color
      ),
    ),
    color: Colors.blue,
  );

  // List of themes
  static final List<Color> themes = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purpleAccent,
    Colors.yellow,
    Colors.cyan,
    Colors.pink, // Added pink
    Colors.deepPurple, // Added deep purple
  ];
}