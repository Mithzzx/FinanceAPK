import 'package:flutter/material.dart';

class MorePage extends StatefulWidget {
  @override
  State<MorePage> createState() => MorePageState();
}

class MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 7 / 6, // Adjusted aspect ratio to reduce card height
          ),
          itemCount: 10, // Number of items
          itemBuilder: (context, index) {
            return Card(
              elevation: 1,
              child: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8), // Rounded edges
                      ),
                      child: Icon(
                        Icons.image, // Placeholder icon
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Item $index',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}