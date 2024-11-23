import 'package:flutter/material.dart';

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
                // Sequencing: 순서를 기반으로 키 값 생성
                final key = 'step${codeSnippets.length}'; // 마지막 인덱스 + 1로 생성
                onAddSnippet(key, snippet);
              } else {
                if (codeSnippets.containsKey(selectedLanguage)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'A snippet for "$selectedLanguage" is already added.',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                onAddSnippet(selectedLanguage, snippet);
              }
              snippetController.clear();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Snippet cannot be empty.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Add Snippet'),
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
              title: Text('Step: ${entry.key}'),
              subtitle: Text(entry.value),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // 삭제 및 키 재정렬
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
        final newKey = 'step$index'; // 새로운 인덱스 기반 키 생성
        updatedSnippets[newKey] = entry.value;
        index++;
      }

      codeSnippets.clear();
      codeSnippets.addAll(updatedSnippets);
    }
  }
}
