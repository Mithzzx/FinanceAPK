import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

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

Widget bottomNavBar1(){
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      ConvexAppBar(
        style: TabStyle.fixedCircle,
        cornerRadius: 25,
        //backgroundColor: widget.theme.canvasColor,
        color: Colors.white,
        //activeColor: widget.theme.canvasColor,
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
              // Skip the center button
              if (index != 2) {
                //widget.onTap(index);
              }
            },
          ),
        ),
      ),
    ],
  );
}
