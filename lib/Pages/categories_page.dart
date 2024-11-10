// lib/Pages/categories_page.dart
import 'package:finance_apk/Pages/subCatogoriesPage.dart';
import 'package:flutter/material.dart';
import '../backend/Categories.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(4.0), // Rectangular with slight rounding
              ),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: category.icon,
              ),
            ),
            title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoriesPage(category: category),
                ),
              );
            },
          );
        },
      ),
    );
  }
}