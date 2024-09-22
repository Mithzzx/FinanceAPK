import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _amount = 0;

  TextEditingController _controller = TextEditingController();

  void _clearText() {
    _controller.clear();  // Clears the text in the TextField
    _calculate("0");
  }

  @override
  void dispose() {
    _controller.dispose();  // Clean up the controller when the widget is disposed
    super.dispose();
  }

  void _calculate(String usd) {
    setState(() {
      _amount = int.parse(usd)*83.99;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    OutlineInputBorder border = const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(166, 37, 44, 30),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(40))
    );
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text("₹${_amount.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 75,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(192, 34, 43, 26)
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    fontSize: 15
                ),
                decoration: InputDecoration(
                    hintText: "Enter the amount in USD",
                    filled: true,
                    fillColor: const Color.fromARGB(119, 239, 240, 228),
                    focusedBorder: border,
                    enabledBorder: border,
                    prefixIcon: const Icon(Icons.monetization_on,
                        color: Color.fromARGB(192, 34, 43, 26)
                    )
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Access the value of the TextField using the controller
                String enteredText = _controller.text;
                _calculate(enteredText);
                // You can also display it in the UI, show an alert, or store it in a variable
              },
              child: Text('Convert'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearText,
        tooltip: 'Clear',
        child: const Icon(Icons.clear),
      ),
    );// This trailing comma makes auto-formatting nicer for build methods.
  }
}
