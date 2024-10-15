import 'package:flutter/material.dart';

class SliderWithDots extends StatefulWidget {
  final List<Widget> widgetList;

  SliderWithDots({required this.widgetList});

  @override
  _SliderWithDotsState createState() => _SliderWithDotsState();
}

class _SliderWithDotsState extends State<SliderWithDots> {
  PageController _pageController = PageController(); // To control the page view
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PageView for the sliding widgets
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.widgetList.length, // Correctly access widgetList
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return widget.widgetList[index]; // Correctly access widgetList
            },
          ),
        ),
        SizedBox(height: 16), // Spacing between slider and dots
        // Row of dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.widgetList.asMap().entries.map((entry) {
            int index = entry.key;  // Access index from the asMap().entries
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.blueAccent
                    : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
