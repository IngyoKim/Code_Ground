import 'package:flutter/material.dart';

class LanguageInput extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String?> onLanguageChanged;

  const LanguageInput({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedLanguage,
        items: const [
          DropdownMenuItem(value: 'C', child: Text('C')),
          DropdownMenuItem(value: 'Python', child: Text('Python')),
          DropdownMenuItem(value: 'Java', child: Text('Java')),
          DropdownMenuItem(value: 'C++', child: Text('C++')),
          DropdownMenuItem(value: 'Dart', child: Text('Dart')),
        ],
        onChanged: onLanguageChanged,
        decoration: const InputDecoration(
          labelText: 'Language',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
