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
    /// 프로그래밍 언어 리스트
    final List<String> languages = ['C', 'C++', 'Java', 'Python', 'Dart'];

    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        DropdownButtonFormField<String>(
          value: selectedLanguage,
          decoration: const InputDecoration(
            labelText: 'Language',
            border: OutlineInputBorder(),
          ),
          items: languages
              .map((language) => DropdownMenuItem(
                    value: language,
                    child: Text(language),
                  ))
              .toList(),
          onChanged: onLanguageChanged,
        ),
      ],
    );
  }
}
