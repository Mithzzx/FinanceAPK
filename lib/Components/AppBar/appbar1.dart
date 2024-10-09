import 'package:finance_apk/Pages/budgets.dart';
import 'package:finance_apk/main.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

MyHomePageState myHomePage = MyHomePageState();

Widget fab1(){
  return Padding(
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
  );
}

Widget bottomNavBar1(theme){
  return Stack(
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
      SizedBox(
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
            //currentIndex: widget.selectedIndex,
            iconSize: 27,
            selectedFontSize: 10,
            unselectedFontSize: 8,
            onTap: (index) {
              if (index != myHomePage.selectedIndex) {
                myHomePage.onItemTapped(index);

                if (index == 0){
                  Navigator.push(
                      myHomePage.context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                  );
                if (index == 1){
                  Navigator.push(
                      myHomePage.context,
                      MaterialPageRoute(builder: (context) => BudgetsPage()),
                  );
                }
              }
              // Skip the center button
              if (index != 2) {
                //widget.onTap(index);
              }
            }},
          ),
        ),
      ),
    ],
  );
}

// lib/custom_app_bar.dart

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  // Constructor to accept the title as a parameter
  const CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.blue,
    );
  }

  // This is necessary to specify the size of the AppBar
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
