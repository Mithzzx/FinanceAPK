import 'package:flutter/material.dart';
import 'package:finance_apk/Components/AppBar/app_bar_1.dart';

void main() {
  runApp(const MyApp());
}
void _onPressed(){
  return;
}
double topIconSize = 27;
double slidingAccountsPadding = homePagePadding+10;
double slidingAccountsSpacing = 10;
double homePagePadding = 8;

Card SlidingAccountsCard(screenSize) {
  return Card(
    elevation: 3,
    child: SizedBox(
      height: 90,
      width:
      ((screenSize - 2 * slidingAccountsPadding) / 2) - 14,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance APK',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 60,),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    IconButton(
                        onPressed: _onPressed,
                        icon: const Icon(Icons.notifications),
                        iconSize: topIconSize,
                    ),
                    IconButton(
                        onPressed: _onPressed,
                        icon: const Icon(Icons.settings),
                      iconSize: topIconSize,
                    )
                  ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _onPressed,
                        icon: const Icon(Icons.menu_sharp),
                        iconSize: topIconSize,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  Row(children: [
                    SizedBox(width: homePagePadding+15),
                    const SizedBox(
                      width: 280,
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25,),
                          Text("TOTAL BALANCE",
                          style:TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          )
                          ),
                          Row(
                            children: [
                              Text("₹",
                                  style:TextStyle(
                                    fontSize: 36,
                                  )
                              ),
                              Text("13,370.98",
                                  style:TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 36,
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Placeholder(
                        fallbackWidth: 140,
                        fallbackHeight: 120,)
                    ],
                  )
                ],
              ),
          SizedBox(height:35),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            child: Row(
              children: List.generate(
                4,
                    (index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: slidingAccountsPadding),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SlidingAccountsCard(MediaQuery.of(context).size.width),
                          SizedBox(height: slidingAccountsSpacing),
                          SlidingAccountsCard(MediaQuery.of(context).size.width),
                        ],
                      ),
                      SizedBox(width: slidingAccountsSpacing),
                      Column(children: [
                        SlidingAccountsCard(MediaQuery.of(context).size.width),
                        SizedBox(height: slidingAccountsSpacing),
                        SlidingAccountsCard(MediaQuery.of(context).size.width),
                      ],
                      ),
                    ],
                  )
                ),
              ),
            ),
          ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width-(homePagePadding+35),
                  child: Center(child: Text("DEMO CARD !")),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width-(homePagePadding+35),
                  child: Center(child: Text("DEMO CARD 2")),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width-(homePagePadding+35),
                  child: Center(child: Text("DEMO CARD 3")),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width-(homePagePadding+35),
                  child: Center(child: Text("DEMO CARD 4")),
                ),
              ),
            ],
          )),
      bottomNavigationBar: appBar1(Theme.of(context)),
      floatingActionButton: fab1(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}