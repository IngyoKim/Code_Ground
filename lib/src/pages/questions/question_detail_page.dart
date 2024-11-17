import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';

class QuestionDetailPage extends StatelessWidget {
  const QuestionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final questionViewModel = Provider.of<QuestionViewModel>(context);
    final question = questionViewModel.selectedQuestion;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Question Details'),
          backgroundColor: Colors.black,
        ),
        body: const Center(child: Text('No question selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(question.title),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title
            Text(
              question.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              question.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Languages
            Text(
              'Languages: ${question.languages.join(', ')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Code Snippets Section
            if (question.codeSnippets.isNotEmpty)
              const Text(
                'Code Snippets:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            const SizedBox(height: 8),

            if (question.codeSnippets.isNotEmpty)
              ...question.codeSnippets.entries.map(
                (entry) {
                  final language = entry.key;
                  final code = entry.value;
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
                              language,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
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
                                code,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
