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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              question.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Languages: ${question.languages.join(', ')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
