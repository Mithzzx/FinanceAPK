import 'package:appinio_animated_toggle_tab/appinio_animated_toggle_tab.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expressions/expressions.dart';
import 'package:finance_apk/Pages/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Components/Date_time_card.dart';
import '../Components/coustom_bottom_sheet.dart';
import '../main.dart';
import '../backend/Categories.dart';
import '../backend/accounts.dart';
import 'categoriespage.dart';

class AddTransactionPage extends StatefulWidget {
  final Category? category;
  final SubCategory? subCategory;

  const AddTransactionPage({super.key, this.category, this.subCategory});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String _selectedTransactionType = 'Income';
<<<<<<< HEAD
  Account _selectedAccount = accounts[0];
=======
  String _selectedAccount = 'SELECT ACCOUNT';
>>>>>>> parent of fb801ae (Accounts DataBase)
  late String fromAccount;
  late String toAccount;
  late String selectedAmount;
  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;
  final PageController _pageController = PageController(viewportFraction: 0.921);
  final TextEditingController _amountController = TextEditingController();
  String _display = '0';
<<<<<<< HEAD
  DateTime? _selectedDateTime;

  void onPressed() async {
    try {
      // Collect the data
      double? amount = double.tryParse(_amountController.text);
      Account? accountName = _selectedAccount;
      Category? category = _selectedCategory;
      DateTime? dateTime = _selectedDateTime;

      // Validate required fields
      List<String> missingFields = [];
      if (amount == null || amount == 0) missingFields.add('Amount');
      if (category == null) missingFields.add('Category');
      if (dateTime == null) missingFields.add('Date and Time');

      if (missingFields.isNotEmpty) {
        // Show dialog box listing the missing data
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Missing Data'),
              content: Text('Please provide the following data:\n${missingFields.join('\n')}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Create a Record object
      Record record = Record(
        amount: amount!, // Use the non-nullable amount
        account: accountName,
        category: category!,
        dateTime: dateTime!,
        notes: "Some notes", // Replace with actual notes
        payee: "Some payee", // Replace with actual payee
        paymentType: "Some payment type", // Replace with actual payment type
        warranty: "Some warranty", // Replace with actual warranty
        status: "Some status", // Replace with actual status
        location: "Some location", // Replace with actual location
        photo: "Some photo", // Replace with actual photo
      );

      // Insert the Record object into the database
      await DatabaseHelper().insertRecord(record);

      // Add the record to the Records list
      Records.add(record);

      Provider.of<ThemeProvider>(context, listen: false).setTheme(ThemeProvider.currentTheme.color);

      // Navigate to home page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle the error (e.g., show a message to the user)
      print('Error: $e');
    }
  }
=======
>>>>>>> parent of fb801ae (Accounts DataBase)

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _selectedSubCategory = widget.subCategory;
  }

  void _updateDisplay(String display) {
    setState(() {
      _display = display;
    });
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Stack(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppinioAnimatedToggleTab(
                    tabTexts: const ['Income', 'Expense', 'Transfer'],
                    callback: (index) {
                      setState(() {
                        _selectedTransactionType = ['Income', 'Expense', 'Transfer'][index];
                        if (_selectedTransactionType == 'Expense') {
                          Provider.of<ThemeProvider>(context, listen: false).setTempTheme(
                              ThemeProvider.themes[0]);
                        } else if (_selectedTransactionType == 'Income') {
                          Provider.of<ThemeProvider>(context, listen: false).setTempTheme(
                              ThemeProvider.themes[1]);
                        } else {
                          Provider.of<ThemeProvider>(context, listen: false).setTempTheme(
                              ThemeProvider.themes[2]);
                        }
                      });
                    },
                    height: 42,
                    boxDecoration: BoxDecoration(
                      color: adjustedColor,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                    ),
                    animatedBoxDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    activeStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    inactiveStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    width: MediaQuery.of(context).size.width - 40,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showCustomBottomSheet(
                      context,
                      SizedBox(
                        height: 380,// Adjust the height as needed
                        child: CalculatorWidget(
                          controller: _amountController,
                          onDisplayChanged: _updateDisplay,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 23.5, top:1),
                    child: Container(
                      height: 85,
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                        color: adjustedColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: AutoSizeText(
                        _display.isEmpty ? 'Enter Amount' : _display,
                        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
                        maxLines: 1,
                        minFontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.only(left: 23),
                  child: Text(
                    'DETAILS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: accounts.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedAccount = accounts[index];
                            print(_selectedAccount.name);
                          });
                        },
                        itemBuilder: (context, index) {
                          return _buildAccountCard(accounts[index]);
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: accounts.length,
                      effect: WormEffect(
                        spacing: 5,
                        dotHeight: 5,
                        dotWidth: 5,
                        activeDotColor: Theme.of(context).colorScheme.primary,
                        dotColor: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                final selectedCategory = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CategoriesPage()),
                                );
                                if (selectedCategory != null) {
                                  setState(() {
                                    _selectedCategory = selectedCategory;
                                  });
                                }
                              },
                              child: Card(
                                color: _selectedCategory?.color ?? null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: SizedBox(
                                  height: 90, // Set the same fixed height
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: _selectedCategory == null
                                        ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.08),
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Text("?"),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text('Category', style: TextStyle(fontSize: 14)),
                                      ],
                                    )
                                        : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.1),
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: _selectedCategory?.icon,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          _selectedSubCategory?.name ?? _selectedCategory!.name,
                                          style: const TextStyle(color: Colors.white, fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 100, // Set the same fixed height
                              child: DateTimeCard(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                      child: Text(
                        'MORE DETAILS',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(thickness: 0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.note),
                      title: Text('Note'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(thickness: 0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Payee'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(thickness: 0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.payment),
                      title: Text('Payment type'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(thickness: 0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.verified_user),
                      title: Text('Warranty'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(thickness: 0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text('Status'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(thickness: 0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Add location'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(thickness: 0.3),
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_camera),
                      title: Text('Attach photo'),
                    ),
                  ],
                ),
                const SizedBox(height: 80)
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80, // Adjust the height as needed
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.25),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SizedBox(
                height: 10,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 12,bottom: 29),
                  child: FilledButton(
                    onPressed: onPressed,
                    child: const Text('Save'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )
                    )
                  ),
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(Account account) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        child: Stack(
          children: [
            Container(
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
                borderRadius: BorderRadius.circular(15),
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
      ),
    );
  }

  void onPressed() {}
}

class CalculatorWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onDisplayChanged;

  const CalculatorWidget({super.key, required this.controller, required this.onDisplayChanged});

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
        widget.controller.text = _calculatedValue.toString();
        widget.onDisplayChanged(_display);
        Navigator.pop(context);
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
      widget.onDisplayChanged(_display);
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
          width: 32,
          height: 4,
          margin: const EdgeInsets.only(top: 12,bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: false,
            padding: const EdgeInsets.only(top: 14, left: 29, right: 29),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.5,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              final buttonText = _getButtonText(index);
              final bgColor = _getButtonColor(index, context);
              final textColor = _getButtonTextColor(index, context);
              return _buildCalcButton(buttonText, bgColor, textColor);
            },
          ),
        ),
      ],
    );
  }

  String _getButtonText(int index) {
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
    if (index < 4 || index == 19) {
      return Theme.of(context).colorScheme.primary.withAlpha(230);
    } else if (index == 2 || index == 3 || index == 7 || index == 11 || index == 15) {
      return Theme.of(context).colorScheme.tertiary.withAlpha(220);
    } else {
      return Theme.of(context).colorScheme.secondaryContainer;
    }
  }

  Color _getButtonTextColor(int index, BuildContext context) {
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
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 23,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}