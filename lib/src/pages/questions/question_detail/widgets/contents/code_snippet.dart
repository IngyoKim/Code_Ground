import 'package:flutter/material.dart';

// 코드 스니펫 카드 위젯
Widget codeSnippet(MapEntry<String, String> entry) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                entry.value,
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// 필터링된 코드 스니펫 표시
Widget filteredCodeSnippets({
  required Map<String, String> codeSnippets,
  required String selectedLanguage,
}) {
  final filteredSnippets = codeSnippets.entries
      .where((entry) => entry.key == selectedLanguage)
      .map<Widget>((entry) => codeSnippet(entry))
      .toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      ...filteredSnippets,
    ],
  );
}
