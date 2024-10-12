import 'dart:io';
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

// lib/custom_bottom_nav_bar.dart

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final theme;

  const CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {

    double navBarHeight = Platform.isIOS ? 87 : 74;
    double conNavBarHeight = Platform.isIOS ? 55 : 75;
    double borderRadius = Platform.isIOS ? 30 : 33;
    double conBorderRadius = Platform.isIOS ? 25 : 28;

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory, // Disables the ripple effect
        highlightColor: Colors.transparent, // Disables highlight
        splashColor: Colors.transparent, // Disables splash color
        hoverColor: Colors.transparent, // Disable hover effect (if applicable)
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ConvexAppBar(
            shadowColor: Colors.grey[800],
            style: TabStyle.fixedCircle,
            cornerRadius: conBorderRadius,
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
            height: conNavBarHeight, // Adjust for visual preference
            curveSize: 90,
          ),
          SizedBox(
            height: navBarHeight, // Set your desired height here
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: InkResponse(
                      splashColor: Colors.red,
                        child: Icon(Icons.next_plan)
                    ),
                    label: 'Budgets',
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
                currentIndex: selectedIndex,
                iconSize: 27,
                selectedFontSize: 10,
                unselectedFontSize: 8,
                onTap: (index) {
                  onItemTapped(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
