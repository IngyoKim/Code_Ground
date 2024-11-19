import 'package:flutter/material.dart';

class CategoryInput extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String?> onCategoryChanged;

  const CategoryInput({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        items: const [
          DropdownMenuItem(value: 'Syntax', child: Text('Syntax')),
          DropdownMenuItem(value: 'Debugging', child: Text('Debugging')),
          DropdownMenuItem(value: 'Output', child: Text('Output')),
          DropdownMenuItem(value: 'Blank', child: Text('Blank')),
          DropdownMenuItem(value: 'Sequencing', child: Text('Sequencing')),
        ],
        onChanged: onCategoryChanged,
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
