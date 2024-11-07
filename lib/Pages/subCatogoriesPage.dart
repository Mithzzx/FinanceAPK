// lib/Pages/subcategories_page.dart
import 'package:flutter/material.dart';
import '../backend/Categories.dart';
import 'addpage.dart';

class SubCategoriesPage extends StatelessWidget {
  final Category category;

  SubCategoriesPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                child: ListTile(
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
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTransactionPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 20.0),
              child: Text(
                'SUBCATEGORIES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                child: Column(
                  children: List.generate(
                    category.subCategories?.length ?? 0,
                        (index) {
                      final subCategory = category.subCategories![index];
                      return Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: category.color,
                                borderRadius: BorderRadius.circular(4.0), // Rectangular with slight rounding
                              ),
                              child: IconTheme(
                                data: const IconThemeData(color: Colors.white),
                                child: subCategory.icon,
                              ),
                            ),
                            title: Text(
                              subCategory.name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTransactionPage(),
                                ),
                              );
                            },
                          ),
                          if (index < category.subCategories!.length - 1)
                             const Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Divider(thickness: 0.3, height: 3,),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}