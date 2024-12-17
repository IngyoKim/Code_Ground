import 'package:flutter/material.dart';
import 'package:code_ground/src/utils/toast_message.dart';

class CodeSnippetInput extends StatelessWidget {
  final String category;
  final String selectedLanguage;
  final Map<String, String> codeSnippets;
  final TextEditingController snippetController;
  final void Function(String, String) onAddSnippet;
  final void Function(String) onDeleteSnippet;

  const CodeSnippetInput({
    super.key,
    required this.category,
    required this.selectedLanguage,
    required this.codeSnippets,
    required this.snippetController,
    required this.onAddSnippet,
    required this.onDeleteSnippet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: snippetController,
          decoration: const InputDecoration(
            labelText: 'Code Snippet',
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            final snippet = snippetController.text.trim();
            if (snippet.isNotEmpty) {
              if (category == 'Sequencing') {
                /// Sequencing: 'i0', 'i1', 'i2' 형식으로 키 값 생성
                final key = 'i${codeSnippets.length}';
                onAddSnippet(key, snippet);
                _reorderKeys();

                /// 키 재정렬
              } else {
                if (codeSnippets.containsKey(selectedLanguage)) {
                  ToastMessage.show(
                    'A snippet for "$selectedLanguage" is already added.',
                  );
                  return;
                }
                onAddSnippet(selectedLanguage, snippet);
              }
              snippetController.clear();
            } else {
              ToastMessage.show('Snippet cannot be empty.');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
          ),
          child: const Text(
            'Add Snippet',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 16),
        if (codeSnippets.isNotEmpty) ...[
          const Text(
            'Added Snippets:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...codeSnippets.entries.map(
            (entry) => ListTile(
              title: Text(entry.key),
              subtitle: Text(
                entry.value,
                style: const TextStyle(fontSize: 14),
                softWrap: true,
                maxLines: null,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  onDeleteSnippet(entry.key);
                  _reorderKeys();
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// 키 값 재정렬 (Sequencing 전용)
  void _reorderKeys() {
    if (category == 'Sequencing') {
      final updatedSnippets = <String, String>{};
      int index = 0;

      for (final entry in codeSnippets.entries) {
        final newKey = 'i$index'; // 'i0', 'i1', 'i2' 형식으로 키 재정렬
        updatedSnippets[newKey] = entry.value;
        index++;
      }

      codeSnippets
        ..clear()
        ..addAll(updatedSnippets);
    }
  }
}
