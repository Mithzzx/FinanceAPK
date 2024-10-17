import 'package:finance_apk/Pages/accountspage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_apk/Pages/theme_provider.dart';
import 'package:expressions/expressions.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../main.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String _selectedTransactionType = 'Income';
  String _selectedAccount = 'SELECT ACCOUNT';
  late String fromAccount;
  late String toAccount;
  late String selectedAmount;

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
    Brightness brightness = Theme.of(context).brightness;
    Color adjustedColor = (brightness == Brightness.light)
        ? darkenColor(scaffoldColor, 0.07)
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
                        Provider.of<ThemeProvider>(context, listen: false).setTheme(
                            ThemeProvider.themes[1]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
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
          ),
          Container(
            color: adjustedColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _selectedTransactionType == 'Transfer'
                    ? [
                  _buildAccountButton('From Account'),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                  _buildAccountButton('To Account'),
                ]
                    : [
                  _buildAccountButton('Account'),
                  _buildCategoryButton('Category'),
                ],
              ),
            ),
          ),
          const Expanded(
            child: CalculatorWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeButton(String type) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return FilledButton.tonal(
          onPressed: () {
            setState(() {
              _selectedTransactionType = type;
              if (type == 'Expense') {
                Provider.of<ThemeProvider>(context, listen: false).setTheme(
                    ThemeProvider.themes[3]);
              } else if (type == 'Income') {
                Provider.of<ThemeProvider>(context, listen: false).setTheme(
                    ThemeProvider.themes[2]);
              } else {
                Provider.of<ThemeProvider>(context, listen: false).setTheme(
                    ThemeProvider.themes[4]);
              }
            });
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              _selectedTransactionType == type
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
            ),
            minimumSize: WidgetStateProperty.all(Size(
                (MediaQuery.of(context).size.width / 3) - 14, 45)),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 5)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: Text(
            type,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  Widget _buildAccountButton(String label) {
    return TextButton(
      onPressed: () async {
        final selectedAccount = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountsPage(
              onAccountSelected: (account) {
                setState(() {
                  if (label == 'From Account') {
                    fromAccount = account;
                    _selectedAccount = fromAccount;
                    print("From Account: $fromAccount");
                  } else if (label == 'To Account') {
                    toAccount = account;
                    _selectedAccount = toAccount;
                    print("From Account: $fromAccount");
                    print("To Account: $toAccount");
                  }
                  else {
                    selectedAmount = account;
                    _selectedAccount = selectedAmount;
                    print("Selected Amount: $selectedAmount");
                  }
                });
              },
            ),
          ),
        );
      },
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 10, color: Color.fromARGB(150, 255, 255, 255)),
          ),
          Text(
            _selectedAccount,
            style: const TextStyle(
                fontSize: 13, color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 10, color: Color.fromARGB(128, 255, 255, 255)),
          ),
          const Text(
            'SELECT CATEGORY',
            style: TextStyle(
                fontSize: 13, color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
    );
  }

  void onPressed() {}
}


// Custom Google-like Calculator Widget
class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _display = '0';
  double _calculatedValue = 0.0;
  double buttonSize = 60.0; // Define button size variable

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '0';
      } else if (buttonText == '=') {
        _calculatedValue = _evaluate(_display);
        _display = _calculatedValue.toString();
      } else if (buttonText == '⌫') {
        _display = _display.length > 1 ? _display.substring(0, _display.length - 1) : '0';
      } else if (buttonText == '( )') {
        int openCount = '('.allMatches(_display).length;
        int closeCount = ')'.allMatches(_display).length;
        bool isOperator = _isOperator(getLastCharacter(_display));
        if ((openCount <= closeCount) || isOperator) {
          _display += '(';
        } else {
          _display += ')';
        }
      } else {
        if (_display == '0') {
          _display = buttonText;
        } else {
          _display += buttonText;
        }
      }
    });
  }

  String getLastCharacter(String input) {
    return input.isNotEmpty ? input.substring(input.length - 1) : '';
  }

  bool _isOperator(String char) {
    return char == '+' || char == '-' || char == '*' || char == '/' || char == '×' || char == '÷';
  }

  double _evaluate(String expression) {
    try {
      final evaluator = const ExpressionEvaluator();
      final parsedExpression = Expression.parse(expression.replaceAll('×', '*').replaceAll('÷', '/'));
      final result = evaluator.eval(parsedExpression, {});
      return result is double ? result : double.parse(result.toString());
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
    Brightness brightness = Theme.of(context).brightness;
    Color adjustedColor = (brightness == Brightness.light)
        ? darkenColor(scaffoldColor, 0.07)
        : lightenColor(scaffoldColor, 0.08);

    Color defaultTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.56,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            color: adjustedColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: AutoSizeText(
            _display,
            style: const TextStyle(fontSize: 88, fontWeight: FontWeight.w400),
            maxLines: 1,
            minFontSize: 20,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.width * 0.1,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 4,
              padding: const EdgeInsets.only(top: 14, left: 29, right: 29),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              children: [
                _buildCalcButton('C', Theme.of(context).colorScheme.primary.withAlpha(230), Colors.white),
                _buildCalcButton('( )', Theme.of(context).colorScheme.primary.withAlpha(230), Colors.white),
                _buildCalcButton('%', Theme.of(context).colorScheme.tertiary.withAlpha(220), Colors.white),
                _buildCalcButton('÷', Theme.of(context).colorScheme.tertiary.withAlpha(220), Colors.white),

                _buildCalcButton('7', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('8', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('9', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('×', Theme.of(context).colorScheme.tertiary.withAlpha(220), Colors.white),

                _buildCalcButton('4', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('5', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('6', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('-', Theme.of(context).colorScheme.tertiary.withAlpha(220), Colors.white),

                _buildCalcButton('1', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('2', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('3', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('+', Theme.of(context).colorScheme.tertiary.withAlpha(220), Colors.white),

                _buildCalcButton('0', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('.', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('⌫', Theme.of(context).colorScheme.secondaryContainer, defaultTextColor),
                _buildCalcButton('=', Theme.of(context).colorScheme.primary.withAlpha(230), Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalcButton(String buttonText, Color bgColor, Color textColor) {
    return GestureDetector(
      onTap: () => _buttonPressed(buttonText),
      child: Container(
        width: buttonSize, // Use button size variable
        height: buttonSize, // Use button size variable
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 29, color: textColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}