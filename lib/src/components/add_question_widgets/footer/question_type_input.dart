import 'package:flutter/material.dart';

class QuestionTypeInput extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String?> onTypeChanged;

  const QuestionTypeInput({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        items: const [
          DropdownMenuItem(value: 'Subjective', child: Text('Subjective')),
          DropdownMenuItem(value: 'Objective', child: Text('Objective')),
        ],
        onChanged: onTypeChanged,
        decoration: const InputDecoration(
          labelText: 'Question Type',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
