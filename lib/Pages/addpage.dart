import 'package:auto_size_text/auto_size_text.dart';
import 'package:expressions/expressions.dart';
import 'package:finance_apk/Pages/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../main.dart';
import '../backend/Categories.dart';
import '../backend/accounts.dart'; // Import the accounts.dart file

class AddTransactionPage extends StatefulWidget {
  final Category? category;
  final SubCategory? subCategory;

  const AddTransactionPage({super.key, this.category, this.subCategory});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String _selectedTransactionType = 'Income';
  String _selectedAccount = 'SELECT ACCOUNT';
  late String fromAccount;
  late String toAccount;
  late String selectedAmount;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _selectedSubCategory = widget.subCategory;
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
                          ThemeProvider.currentTheme.color,
                        );
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
            width: double.infinity,
            color: adjustedColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CupertinoSegmentedControl<String>(
                children: const {
                  'Income': Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Income'),
                  ),
                  'Expense': Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Expense'),
                  ),
                  'Transfer': Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Transfer'),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _selectedTransactionType = value;
                    if (value == 'Expense') {
                      Provider.of<ThemeProvider>(context, listen: false).setTempTheme(
                          ThemeProvider.themes[0]);
                    } else if (value == 'Income') {
                      Provider.of<ThemeProvider>(context, listen: false).setTempTheme(
                          ThemeProvider.themes[1]);
                    } else {
                      Provider.of<ThemeProvider>(context, listen: false).setTempTheme(
                          ThemeProvider.themes[2]);
                    }
                  });
                },
                groupValue: _selectedTransactionType,
                borderColor: Theme.of(context).colorScheme.primary,
                selectedColor: Theme.of(context).colorScheme.primary,
                unselectedColor: Theme.of(context).colorScheme.secondaryContainer,
                pressedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
          ),
          Container(
            color: adjustedColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: accounts.length, // Use the length of the accounts list
                      onPageChanged: (index) {
                        setState(() {
                          _selectedAccount = accounts[index].name; // Update the selected account
                        });
                      },
                      itemBuilder: (context, index) {
                        return _buildAccountCard(accounts[index]); // Pass the account object
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: accounts.length, // Use the length of the accounts list
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Theme.of(context).colorScheme.primary,
                      dotColor: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
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

  Widget _buildAccountCard(Account account) {
    return Card(
      elevation: 3,
      child: Stack(
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  account.color.withOpacity(0.7),
                  account.color,
                  account.color.withOpacity(1.0),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      account.accountType.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      account.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      account.currency,
                      style: const TextStyle(
                        color: Color.fromARGB(150, 255, 255, 255),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onPressed() {}
}
class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _display = '0';
  double _calculatedValue = 0.0;

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
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              padding: const EdgeInsets.only(top: 14, left: 29, right: 29),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns
                mainAxisSpacing: 14, // Spacing between rows
                crossAxisSpacing: 14, // Spacing between columns
                childAspectRatio: 1.5, // Aspect ratio of each item
              ),
              itemCount: 20, // Number of items
              itemBuilder: (context, index) {
                // Define your button texts and colors here
                final buttonText = _getButtonText(index);
                final bgColor = _getButtonColor(index, context);
                final textColor = _getButtonTextColor(index, context);
                return _buildCalcButton(buttonText, bgColor, textColor);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getButtonText(int index) {
    // Define your button texts based on the index
    const buttonTexts = [
      'C', '( )', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '0', '.', '⌫', '='
    ];
    return buttonTexts[index];
  }

  Color _getButtonColor(int index, BuildContext context) {
    // Define your button background colors based on the index
    if (index < 4 || index == 19) {
      return Theme.of(context).colorScheme.primary.withAlpha(230);
    } else if (index == 2 || index == 3 || index == 7 || index == 11 || index == 15) {
      return Theme.of(context).colorScheme.tertiary.withAlpha(220);
    } else {
      return Theme.of(context).colorScheme.secondaryContainer;
    }
  }

  Color _getButtonTextColor(int index, BuildContext context) {
    // Define your button text colors based on the index
    if (index < 4 || index == 19 || index == 2 || index == 3 || index == 7 || index == 11 || index == 15) {
      return Colors.white;
    } else {
      return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    }
  }

  Widget _buildCalcButton(String buttonText, Color bgColor, Color textColor) {
    return GestureDetector(
      onTap: () => _buttonPressed(buttonText),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0), // Rectangular shape with slight rounding
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 23, color: textColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}