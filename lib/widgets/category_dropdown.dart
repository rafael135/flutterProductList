import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String?> onChanged;
  const CategoryDropdown({super.key, required this.categories, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selected,
        items: categories
            .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ))
            .toList(),
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }
}
