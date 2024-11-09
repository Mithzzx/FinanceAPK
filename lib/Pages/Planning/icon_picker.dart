import 'package:flutter/material.dart';

class IconPicker extends StatelessWidget {
  final IconData icon;
  final ValueChanged<IconData> onIconChanged;

  IconPicker({required this.icon, required this.onIconChanged});

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.star,
      Icons.favorite,
      Icons.thumb_up,
      Icons.home,
      Icons.settings,
      Icons.work,
      Icons.school,
      Icons.pets,
      Icons.cake,
      Icons.local_cafe,
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onIconChanged(icons[index]);
          },
          child: Icon(
            icons[index],
            color: icons[index] == icon ? Colors.blue : Colors.black,
          ),
        );
      },
    );
  }
}