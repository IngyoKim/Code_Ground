// 언어 선택 위젯
import 'package:flutter/material.dart';

Widget languageSelector({
  required List<String> languages,
  required String selectedLanguage,
  required void Function(String) onLanguageSelected,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Wrap(
        spacing: 8.0, // 버튼 간의 가로 간격
        runSpacing: 8.0, // 버튼 간의 세로 간격
        children: languages.map<Widget>(
          (language) {
            final isSelected = language == selectedLanguage;
            return ElevatedButton(
              onPressed: () {
                onLanguageSelected(language);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? Colors.blue
                    : Colors.grey[300], // 선택된 언어는 파란색, 나머지는 회색
                foregroundColor: isSelected
                    ? Colors.white
                    : Colors.black, // 선택된 언어는 흰색 텍스트, 나머지는 검정
              ),
              child: Text(language),
            );
          },
        ).toList(),
      ),
    ],
  );
}
