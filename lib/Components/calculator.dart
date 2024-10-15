import 'package:flutter/material.dart';

class CalculatorWidget extends StatefulWidget {

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display screen
        Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.centerRight,
          child: Text(
            _display,
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(thickness: 1, color: Colors.grey[300]),

        // Calculator buttons grid
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            padding: EdgeInsets.all(16),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildCalcButton('7', Colors.grey[800]!, Colors.white),
              _buildCalcButton('8', Colors.grey[800]!, Colors.white),
              _buildCalcButton('9', Colors.grey[800]!, Colors.white),
              _buildCalcButton('C', Colors.orange, Colors.white),

              _buildCalcButton('4', Colors.grey[800]!, Colors.white),
              _buildCalcButton('5', Colors.grey[800]!, Colors.white),
              _buildCalcButton('6', Colors.grey[800]!, Colors.white),
              _buildCalcButton('+', Colors.blueAccent, Colors.white),

              _buildCalcButton('1', Colors.grey[800]!, Colors.white),
              _buildCalcButton('2', Colors.grey[800]!, Colors.white),
              _buildCalcButton('3', Colors.grey[800]!, Colors.white),
              _buildCalcButton('-', Colors.blueAccent, Colors.white),

              _buildCalcButton('0', Colors.grey[800]!, Colors.white),
              _buildCalcButton('.', Colors.grey[800]!, Colors.white),
              _buildCalcButton('=', Colors.orange, Colors.white),
              _buildCalcButton('/', Colors.blueAccent, Colors.white),
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
            style: TextStyle(fontSize: 24, color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}