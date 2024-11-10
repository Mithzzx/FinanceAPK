// lib/pages/category_selection_page.dart
import 'package:flutter/material.dart';
import '../backend/Categories.dart';

class CategorySelectionPage extends StatefulWidget {
  final List<int> initialSelection;

  const CategorySelectionPage({
    Key? key,
    required this.initialSelection,
  }) : super(key: key);

  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  late Map<int, bool> selectedCategories;
  Map<String, bool> selectedSubCategories = {};

  @override
  void initState() {
    super.initState();
    // Initialize selected categories from initial selection
    selectedCategories = {
      for (var category in categories)
        category.id: widget.initialSelection.contains(category.id)
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Categories'),
        actions: [
          TextButton(
            onPressed: () {
              // Return selected category IDs
              Navigator.pop(
                context,
                selectedCategories.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList(),
              );
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isExpanded = selectedCategories[category.id] ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              children: [
                // Main category checkbox
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: IconTheme(
                      data: const IconThemeData(color: Colors.white),
                      child: category.icon,
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (category.subCategories != null)
                        IconButton(
                          icon: Icon(
                            isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedCategories[category.id] =
                              !(selectedCategories[category.id] ?? false);
                            });
                          },
                        ),
                      Checkbox(
                        value: selectedCategories[category.id] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            selectedCategories[category.id] = value ?? false;
                            // If category is unchecked, uncheck all its subcategories
                            if (!(value ?? false) && category.subCategories != null) {
                              for (var subCategory in category.subCategories!) {
                                selectedSubCategories[
                                '${category.id}_${subCategory.name}'] = false;
                              }
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Subcategories expansion
                if (isExpanded && category.subCategories != null)
                  Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      children: category.subCategories!.map((subCategory) {
                        String subCategoryKey = '${category.id}_${subCategory.name}';
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: category.color.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: IconTheme(
                              data: const IconThemeData(color: Colors.white),
                              child: subCategory.icon,
                            ),
                          ),
                          title: Text(subCategory.name),
                          trailing: Checkbox(
                            value: selectedSubCategories[subCategoryKey] ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                selectedSubCategories[subCategoryKey] =
                                    value ?? false;
                                // If any subcategory is checked, ensure the main category is checked
                                if (value ?? false) {
                                  selectedCategories[category.id] = true;
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}