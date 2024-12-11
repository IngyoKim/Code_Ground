import 'dart:math';
import 'package:flutter/material.dart';

Widget sequencingSubmit({
  required Map<String, String> codeSnippets,
  required ValueChanged<List<String>>
      onSubmit, // List<int> -> List<String>으로 수정
}) {
  // 랜덤으로 순서를 섞기
  final List<MapEntry<String, String>> entries = codeSnippets.entries.toList();
  entries.shuffle(Random());

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      void reorderSnippets(int oldIndex, int newIndex) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final entry = entries.removeAt(oldIndex);
        entries.insert(newIndex, entry);
        setState(() {});
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '길게 눌러서 순서를 바꾸세요.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: reorderSnippets,
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                key: ValueKey(entry.key),
                margin: const EdgeInsets.symmetric(vertical: 4),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final orderedKeys =
                  entries.map((entry) => entry.key).toList(); // 그대로 String 사용
              onSubmit(orderedKeys);
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
