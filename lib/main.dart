import 'dart:convert';

import 'package:finance_apk/secreats.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

<<<<<<< Updated upstream
  TextEditingController _controller = TextEditingController();

  void _clearText() {
    _controller.clear();  // Clears the text in the TextField
    _calculate("0");
=======
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    String cityName = "Bengaluru,in";
    try {
      final res = await http.get(
          Uri.parse(
              "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$myApiKey"));

      final data = jsonDecode(res.body);

      if (data['cod'] != "200")
      {
        throw "An unexpected Error occurred";
      }
      print(data["list"][0]["main"]["temp"]);

    } catch (e) {
      print(e.toString());
    }
  }

  void _refresh()
  {
    return;
>>>>>>> Stashed changes
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
    // by the _incrementCounter method above
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
<<<<<<< Updated upstream
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
=======
      body:Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 200,
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation:20,
                      child: Stack(
                        children: [
                          ClipRect(
                            child:  Ink.image(
                              image:const AssetImage('asset/pexels-eberhardgross-844297.jpg'),
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [],
                                ),
                                Text("Bangalore",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding:EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.cloud),
                                    SizedBox(width: 12,),
                                    Text("Cloudy",
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),),
                                  ],
                                ),
                                Text("20°",
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w600,
                                    )
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  )
              ),
              const SizedBox(height: 30,),
              const Text("Forecast",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _forecastCard(const Icon(Icons.cloud),"19°","3:00"),
                    _forecastCard(const Icon(Icons.cloud),"18°","4:00"),
                    _forecastCard(const Icon(Icons.cloud),"17°","5:00"),
                    _forecastCard(const Icon(Icons.cloud),"16°","6:00"),
                    _forecastCard(const Icon(Icons.cloud),"15°","7:00"),
                    _forecastCard(const Icon(Icons.cloud),"15°","8:00"),
                    _forecastCard(const Icon(Icons.cloud),"14°","9:00"),
                    _forecastCard(const Icon(Icons.cloud),"13°","10:00"),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              const Text("Additional Information",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _addInfoCard(Image.asset(
                    'asset/001-humidity.png',
                    fit: BoxFit.cover,),"Humidity","000"),
                  _addInfoCard(Image.asset(
                    'asset/002-windy.png',
                    fit: BoxFit.cover,),"Wind Speed","000"),
                  _addInfoCard(Image.asset(
                    'asset/003-gauge.png',
                    fit: BoxFit.cover,
                    scale: 0.01,),"Pressure","000"),
                ],
              )
            ],
          ),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======


>>>>>>> Stashed changes
