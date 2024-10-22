import 'package:flutter/material.dart';

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
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.dark ? Colors.black : null,
        scrolledUnderElevation: 3,
        shadowColor: brightness == Brightness.dark ? Colors.grey[800] : null,
      ),
      cardTheme: CardTheme(
        color: brightness == Brightness.dark ? const Color.fromARGB(255, 25, 25, 25) : null,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lighterColor, // Use lighter color
        ),
      ),
    );
    currentTheme = _themeData; // Update currentTheme
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
    );
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
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 3,
      shadowColor: Colors.grey[800],
      backgroundColor:Colors.black,
    ),
    cardTheme: const CardTheme(
      color: Color.fromARGB(255, 25, 25, 25),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color.lerp(Colors.blue, Colors.white, 0.2), // Use lighter color
      ),
    ),
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