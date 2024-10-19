import 'dart:io';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:finance_apk/Pages/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final theme;

  const CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.theme,
  });

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with TickerProviderStateMixin {
  late AnimationController _homeController;
  late AnimationController _budgetsController;
  late AnimationController _statsController;
  late AnimationController _moreController;

  @override
  void initState() {
    super.initState();
    _homeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _budgetsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _moreController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _homeController.dispose();
    _budgetsController.dispose();
    _statsController.dispose();
    _moreController.dispose();
    super.dispose();
  }

  void _onIconTapped(int index) {
    widget.onItemTapped(index);
    switch (index) {
      case 0:
        _homeController.forward().then((_) => _homeController.reverse());
        break;
      case 1:
        _budgetsController.forward().then((_) => _budgetsController.reverse());
        break;
      case 3:
        _statsController.forward().then((_) => _statsController.reverse());
        break;
      case 4:
        _moreController.forward().then((_) => _moreController.reverse());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double navBarHeight = Platform.isIOS ? 87 : 74;
    double conNavBarHeight = Platform.isIOS ? 55 : 75;
    double borderRadius = Platform.isIOS ? 30 : 33;
    double conBorderRadius = Platform.isIOS ? 25 : 28;

    Color lighterColor = Provider.of<ThemeProvider>(context).lighterColor;

      return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ConvexAppBar(
            shadowColor: Colors.grey[800],
            style: TabStyle.fixedCircle,
            cornerRadius: conBorderRadius,
            backgroundColor: widget.theme.canvasColor,
            color: Colors.white,
            activeColor: widget.theme.canvasColor,
            items: const [
              TabItem(
                icon: Icon(null),
                title: '',
              ),
            ],
            initialActiveIndex: 0,
            elevation: 3,
            height: conNavBarHeight,
            curveSize: 90,
          ),
          SizedBox(
            height: navBarHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: AnimatedBuilder(
                      animation: _homeController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + _homeController.value * 0.2,
                          child: child,
                        );
                      },
                      child: Icon(Icons.home,)
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedBuilder(
                      animation: _budgetsController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + _budgetsController.value * 0.2,
                          child: child,
                        );
                      },
                      child: const Icon(Icons.next_plan),
                    ),
                    label: 'Budgets',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(null),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedBuilder(
                      animation: _statsController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + _statsController.value * 0.2,
                          child: child,
                        );
                      },
                      child: const Icon(Icons.bar_chart),
                    ),
                    label: 'Stats',
                  ),
                  BottomNavigationBarItem(
                    icon: AnimatedBuilder(
                      animation: _moreController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + _moreController.value * 0.2,
                          child: child,
                        );
                      },
                      child: const Icon(Icons.more_horiz),
                    ),
                    label: 'More',
                  ),
                ],
                currentIndex: widget.selectedIndex,
                iconSize: 27,
                selectedFontSize: 10,
                unselectedFontSize: 8,
                selectedItemColor: lighterColor,
                onTap: _onIconTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
}