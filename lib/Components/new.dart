import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SliderWithDots(),
    );
  }
}

class SliderWithDots extends StatefulWidget {
  @override
  _SliderWithDotsState createState() => _SliderWithDotsState();
}

class _SliderWithDotsState extends State<SliderWithDots> {
  // Controller to manage page scrolling and snapping
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slider with Dots & Snapping'),
      ),
      body: Column(
        children: [
          // Slider with PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                Container(
                  color: Colors.red,
                  child: Center(child: Text('Page 1', style: TextStyle(fontSize: 24, color: Colors.white))),
                ),
                Container(
                  color: Colors.green,
                  child: Center(child: Text('Page 2', style: TextStyle(fontSize: 24, color: Colors.white))),
                ),
                Container(
                  color: Colors.blue,
                  child: Center(child: Text('Page 3', style: TextStyle(fontSize: 24, color: Colors.white))),
                ),
              ],
            ),
          ),

          // Dots indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmoothPageIndicator(
              controller: _pageController,  // PageController
              count: 3,  // Number of pages
              effect: WormEffect(  // Choose the effect style for the dots
                dotHeight: 12,
                dotWidth: 12,
                spacing: 16,
                activeDotColor: Colors.blue,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
