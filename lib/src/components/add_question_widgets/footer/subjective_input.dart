import 'package:flutter/material.dart';

class SubjectiveAnswerInput extends StatelessWidget {
  final TextEditingController subjectiveAnswerController;

  const SubjectiveAnswerInput({
    super.key,
    required this.subjectiveAnswerController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: subjectiveAnswerController,
        decoration: const InputDecoration(
          labelText: 'Answer (Subjective)',
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
