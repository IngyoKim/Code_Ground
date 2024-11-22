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
                // Sequencing: 키 값 자동 생성
                final key = 'list${codeSnippets.length.toString()}';
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
              title: Text('Language: ${entry.key}'),
              subtitle: Text(entry.value),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDeleteSnippet(entry.key),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
