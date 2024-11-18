import 'package:flutter/material.dart';

class CodeSnippetWidget extends StatelessWidget {
  final String selectedCategory;
  final String selectedLanguage;
  final Map<String, String> codeSnippets;
  final TextEditingController snippetController;
  final void Function(String, String) onAddSnippet;
  final void Function(String) onDeleteSnippet;
  final void Function(String) onLanguageChange;
  final bool showAddButton;
  final bool showDeleteButton;

  const CodeSnippetWidget({
    super.key,
    required this.selectedCategory,
    required this.selectedLanguage,
    required this.codeSnippets,
    required this.snippetController,
    required this.onAddSnippet,
    required this.onDeleteSnippet,
    required this.onLanguageChange,
    this.showAddButton = true,
    this.showDeleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedLanguage,
          items: const [
            DropdownMenuItem(value: 'C', child: Text('C')),
            DropdownMenuItem(value: 'Python', child: Text('Python')),
            DropdownMenuItem(value: 'Java', child: Text('Java')),
            DropdownMenuItem(value: 'C++', child: Text('C++')),
            DropdownMenuItem(value: 'Dart', child: Text('Dart')),
          ],
          onChanged: (value) {
            if (value != null) {
              onLanguageChange(value);
              if (selectedCategory != 'Sequencing') {
                snippetController.clear();
                if (selectedCategory == 'Syntax') {
                  codeSnippets.clear();
                }
              }
            }
          },
          decoration: const InputDecoration(labelText: 'Language'),
        ),
        if (selectedCategory != 'Sequencing') ...[
          const SizedBox(height: 8),
          TextField(
            controller: snippetController,
            decoration: const InputDecoration(labelText: 'Code Snippet'),
            onChanged: (value) {
              if (value.isEmpty) {
                onDeleteSnippet(selectedLanguage);
              } else if (selectedCategory == 'Syntax') {
                onAddSnippet(selectedLanguage, value);
              }
            },
          ),
          if (showAddButton) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (snippetController.text.isNotEmpty) {
                  onAddSnippet(selectedLanguage, snippetController.text);
                  snippetController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Code Snippet cannot be empty!'),
                  ));
                }
              },
              child: const Text('Add Snippet'),
            ),
          ],
          const SizedBox(height: 16),
          if (codeSnippets.isNotEmpty)
            ...codeSnippets.entries.map(
              (entry) => ListTile(
                title: Text('Language: ${entry.key}'),
                subtitle: Text(entry.value),
                trailing: showDeleteButton
                    ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDeleteSnippet(entry.key),
                      )
                    : null,
              ),
            ),
        ],
      ],
    );
  }
}
