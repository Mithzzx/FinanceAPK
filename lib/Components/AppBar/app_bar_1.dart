import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

Widget appBar1(theme){
  return  Stack(
    alignment: Alignment.bottomCenter,
    children: [
      ConvexAppBar(
        style: TabStyle.fixedCircle,
        cornerRadius: 25,
        backgroundColor: theme.canvasColor,
        color: Colors.white,
        activeColor: theme.canvasColor,
        items: const [
          TabItem(
            icon: Icon(null), // Larger Icon
            title: '', // No title for the middle icon
          ),
        ],
        initialActiveIndex: 0, // optional, default as 0
        elevation: 5,
        height: 55, // Adjust for visual preference
        curveSize: 90,
      ),
      Container(
        height: 87, // Set your desired height here
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
                icon: Icon(Icons.access_time_outlined),
                label: 'Plannings',
              ),
              BottomNavigationBarItem(
                icon: Icon(null), // Placeholder for the center button
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
            //currentIndex: _selectedIndex,
            iconSize: 27,
            selectedFontSize: 10,
            unselectedFontSize: 8,
            onTap: (index) {
              // Skip the center button
              if (index != 2) {
              }
            },
          ),
        ),
      ),
    ],
  );
}
Widget fab1(){
  return Padding(
    padding: const EdgeInsets.only(top: 17), // Move the button down
    child: FloatingActionButton(
      onPressed: () {
        //_onItemTapped(2); // Center button taps to "Add Page"
      },
      child: Icon(Icons.add,color: Colors.white,),
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
  );
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
      ),

      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //int _selectedIndex = 0;

  // List of widget options for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Plannings Page'),
    Text('Add Page'),
    Text('Stats Page'),
    Text('More Page'),
  ];

  ///void _onItemTapped(int index) {
  ///  setState(() {
  ///    _selectedIndex = index;
  ///  });
  ///}
  int selectedPage = 0;

  final _pageOptions = [
    const Text('Home Page'),
    const Text('Plannings Page'),
    const Text('Add Page'),
    const Text('Stats Page'),
    const Text('More Page'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convex Bottom Nav Example'),
      ),
      body: Center(
        child: _pageOptions[selectedPage],
      ),
      bottomNavigationBar: appBar1(Theme.of(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: fab1()
    );
  }
}
