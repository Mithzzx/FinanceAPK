import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'backend/accounts.dart';

void main() {
  runApp(const MyApp());
}

double topIconSize = 27;
double slidingAccountsPadding = homePagePadding+10;
double slidingAccountsSpacing = 10;
double homePagePadding = 8;


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

  void _onPressed() {
  }

  Widget SlidingAccountsCard(Account account) {
    return Card(
      elevation: 3,
      child: Stack(
        children: [
          Container(
            height: 90,
            width:
            ((MediaQuery.of(context).size.width - 2 * slidingAccountsPadding) / 2) - 14,
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
                    Icon(account.accountType.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(account.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Text(account.balance.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(account.currency,
                      style: const TextStyle(
                        color: Color.fromARGB(150, 255,255,255),
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

  Widget SlidingAccountsCon(cards) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: slidingAccountsPadding),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Column(
              children: [
                cards[0],
                SizedBox(height: slidingAccountsSpacing),
                cards[2],
              ],
            ),
            SizedBox(width: slidingAccountsSpacing),
            Column(children: [
              cards[1],
              SizedBox(height: slidingAccountsSpacing),
              cards[3],
            ],
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    List<Widget> SACointainers = _BuildSlidingAccountsCon(accounts);

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 60,),
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
              ), // Top Icons
              const SizedBox(height: 10),
              Stack(
                children: [
                  Row(children: [
                    SizedBox(width: homePagePadding+15),
                    Container(
                      width: 280,
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25,),
                          const Text("TOTAL BALANCE",
                          style:TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          )
                          ),
                          const Row(
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
                          ),// Total Balance
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              FilledButton.tonal(onPressed: _onPressed,
                                  style: ButtonStyle(
                                   minimumSize: MaterialStateProperty.all(const Size(85, 35)),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>
                                      (const EdgeInsets.symmetric(horizontal: 5)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.monetization_on,size: 15,),
                                      SizedBox(width: 2,),
                                      Text("₹36.44",
                                      style: TextStyle(
                                        fontSize: 11.5,
                                      ),),
                                    ],
                                  )
                              ),
                              TextButton(onPressed: _onPressed, 
                                  child: const Row(
                                    children: [
                                      Text("Cashback saved",
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 2),
                                        child: Text(" >",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),// Cashback saved
                        ],
                      ),
                    )
                  ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.translate(
                        offset: const Offset(55,0),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Card(
                              color: Colors.blue,
                                elevation:20,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 50),
                                  child: Container(
                                    width: 165, // Set the width of the card
                                    height: 110, // Set the height of the card
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10), // Ensures image follows the card's rounded corners
                                      child: Image.asset(
                                        'asset/images/cards/card2.JPEG', // Replace with your image URL
                                        fit: BoxFit.cover, // Ensures the image covers the entire card without distortion
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            Card(
                                elevation:20,
                                child: Container(
                                  width: 195, // Set the width of the card
                                  height: 130, // Set the height of the card
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Ensures image follows the card's rounded corners
                                    child: Image.asset(
                                      'asset/images/cards/card1.JPEG', // Replace with your image URL
                                      fit: BoxFit.cover, // Ensures the image covers the entire card without distortion
                                    ),
                                  ),
                                ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),// Total Balance
          const SizedBox(height:25),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            child: Row(
              children: SACointainers,
            ),
          ),// Sliding Accounts
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width-(homePagePadding+35),
                  child: const Center(child: Text("DEMO CARD !")),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width-(homePagePadding+35),
                  child: const Center(child: Text("DEMO CARD 2")),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width-(homePagePadding+35),
                  child: const Center(child: Text("DEMO CARD 3")),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                child: SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width-(homePagePadding+35),
                  child: const Center(child: Text("DEMO CARD 4")),
                ),
              ),
            ],
          )),
      bottomNavigationBar:Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ConvexAppBar(
            style: TabStyle.fixedCircle,
            cornerRadius: 25,
            backgroundColor: Theme.of(context).canvasColor,
            color: Colors.white,
            activeColor: Theme.of(context).canvasColor,
            items: const [
              TabItem(
                icon: Icon(null), // Larger Icon
                title: '', // No title for the middle icon
              ),
            ],
            initialActiveIndex: 0, // optional, default as 0
            elevation: 5,
            height: 60, // Adjust for visual preference
            curveSize: 90,
          ),
          SizedBox(
            height: 85, // Set your desired height here
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_wallet),
                    label: 'Budgets',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(null), // Placeholder for the center button
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.access_time_outlined),
                    label: 'Plannings',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: 'Stats',
                  ),
                ],
                currentIndex: _selectedIndex,
                iconSize: 27,
                selectedFontSize: 10,
                unselectedFontSize: 8,
                onTap: (index) {
                  // Skip the center button
                  if (index != 2) {
                    _onItemTapped(index);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 17), // Move the button down
        child: FloatingActionButton(
          onPressed: () {
            //_onItemTapped(2); // Center button taps to "Add Page"
          },
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _BuildSlidingAccountsCon(accounts) {
    List<Widget> containers = [];
    var blankcard = Card(
      elevation: 3,
      child: SizedBox(
        height: 90,
        width: ((MediaQuery.of(context).size.width - 2 * slidingAccountsPadding) / 2) - 14,
      ),
    );
    int j=0;
    for (var p = 0; p < accounts.length/4; p++) {
      List<Widget> cards = [];
      for (var i = 0; i < 4; i++) {
        if (j < accounts.length) {
          cards.add(SlidingAccountsCard(accounts[j]));
          j++;
        } else {
          cards.add(blankcard);
        }
      }
      containers.add(SlidingAccountsCon(cards));
    }
    return containers;
  }
}