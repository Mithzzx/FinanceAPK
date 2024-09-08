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
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.tealAccent,
        // Add more custom dark theme properties here
      ), // This sets the dark theme
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Currency Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _refresh()
  {
    print("hoi");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh_sharp))
        ],
        title: const Text("Weather",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600
      ),
        ),
      ),
      body:Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width:400,
              height: 200,
              child: const Card(
                elevation:20,
              )
            ),
            const SizedBox(height: 30,),
            const Text("Forecast",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16,),
            Container(
                width:400,
                height: 120,
                child: const Card(
                  elevation:20,
                )
            ),
            const SizedBox(height: 30,),
            const Text("Additional Informations",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16,),
            Container(
                width:400,
                height: 120,
                child: const Card(
                  elevation:20,
                )
            ),
          ],
        ),
      ),
    );
  }
}
