import 'package:finance_apk/main.dart';
import 'package:flutter/material.dart';

// AddTransactionPage implementation
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {

  Color darkenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - amount)).toInt(),
      (color.green * (1 - amount)).toInt(),
      (color.blue * (1 - amount)).toInt(),
    );
  }

  Color lightenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red + ((255 - color.red) * amount)).toInt(),
      (color.green + ((255 - color.green) * amount)).toInt(),
      (color.blue + ((255 - color.blue) * amount)).toInt(),
    );
  }


  String _selectedTransactionType = 'Income';
  // Default transaction type

  @override
  Widget build(BuildContext context) {
    Color scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    // Get the current brightness
    Brightness brightness = Theme.of(context).brightness;

    // Adjust color based on theme
    Color adjustedColor = (brightness == Brightness.light)
        ? darkenColor(scaffoldColor, 0.07) // Darken for light mode
        : lightenColor(scaffoldColor, 0.08);

    var topIconSize = 25.0;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            color: adjustedColor,
          ),
          Container(
            color: adjustedColor,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onPressed,
                      icon: const Icon(Icons.check),
                      iconSize: topIconSize,
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Navigate to Add Transaction Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>MainPage()),  // Navigate to the new page
                        );
                      },
                      icon: const Icon(Icons.close),
                      iconSize: topIconSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Row to indicate transaction type
          Container(
            color: adjustedColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTransactionTypeButton('Income'),
                  _buildTransactionTypeButton('Expense'),
                  _buildTransactionTypeButton('Transfer'),
                ],
              ),
            ),
          ),// Display selected transaction type
          // Google-like calculator widget
          const Expanded(
            child: CalculatorWidget(),
          ),
        ],
      ),
    );
  }

  // Function to build each transaction type button
  Widget _buildTransactionTypeButton(String type) {
    return FilledButton.tonal(
      onPressed: () {
        setState(() {
          _selectedTransactionType = type;
          if (type == 'Expense') {
            // Change color based on transaction type
            // _selectedTransactionType = type;
          } else if (type == 'Income') {
            // Change color based on transaction type
            // _selectedTransactionType = type;
          } else {
            // Change color based on transaction type
            // _selectedTransactionType = type;
          }
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          _selectedTransactionType == type ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer,
        ),
        minimumSize: WidgetStateProperty.all( Size((MediaQuery.of(context).size.width/3)-14, 45)),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>
          (const EdgeInsets.symmetric(horizontal: 5)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Text(
        type,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  void onPressed() {
  }
}

// Custom Google-like Calculator Widget
class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _display = '0';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '0';
      } else if (buttonText == '=') {
        // Calculate the result
        _display = _evaluate(_display).toString();
      } else {
        if (_display == '0') {
          _display = buttonText;
        } else {
          _display += buttonText;
        }
      }
    });
  }

  double _evaluate(String expression) {
    // Simple evaluation logic (for demonstration purposes)
    try {
      return double.parse(expression);
    } catch (e) {
      return 0;
    }
  }

  Color darkenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - amount)).toInt(),
      (color.green * (1 - amount)).toInt(),
      (color.blue * (1 - amount)).toInt(),
    );
  }

  Color lightenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red + ((255 - color.red) * amount)).toInt(),
      (color.green + ((255 - color.green) * amount)).toInt(),
      (color.blue + ((255 - color.blue) * amount)).toInt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    // Get the current brightness
    Brightness brightness = Theme.of(context).brightness;

    // Adjust color based on theme
    Color adjustedColor = (brightness == Brightness.light)
        ? darkenColor(scaffoldColor, 0.07) // Darken for light mode
        : lightenColor(scaffoldColor, 0.08);

    Color defaultTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return Column(
      children: [
        // Display screen
        Container(
          height: MediaQuery.of(context).size.width * 0.63,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            color: adjustedColor, // Background color
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0), // Radius for bottom left corner
              bottomRight: Radius.circular(30.0), // Radius for bottom right corner
            ),
          ),
          child: Text(
            _display,
            style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w400),
          ),
        ),

        // Calculator buttons grid
        Expanded(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            shrinkWrap: true,
            crossAxisCount: 4,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildCalcButton('7', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('8', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('9', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('C', Theme.of(context).colorScheme.primary.withAlpha(230), Colors.white),

              _buildCalcButton('4', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('5', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('6', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('+', Theme.of(context).colorScheme.tertiary.withAlpha(220), Colors.white),

              _buildCalcButton('1', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('2', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('3', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('-', Theme.of(context).colorScheme.tertiary.withAlpha(220), Colors.white),

              _buildCalcButton('0', Theme.of(context).colorScheme.secondaryContainer,defaultTextColor),
              _buildCalcButton('.', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
              _buildCalcButton('=', Theme.of(context).colorScheme.primary.withAlpha(230), Colors.white),
              _buildCalcButton('/', Theme.of(context).colorScheme.tertiary.withAlpha(220), Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalcButton(String buttonText, Color bgColor, Color textColor) {
    return GestureDetector(
      onTap: () => _buttonPressed(buttonText),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,  // Rounded button
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 29, color: textColor,fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
