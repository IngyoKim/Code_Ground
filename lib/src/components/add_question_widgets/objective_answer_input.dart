import 'package:flutter/material.dart';

class ObjectiveAnswerInput extends StatelessWidget {
  final List<String> answerChoices;
  final String? selectedAnswer;
  final ValueChanged<String> onAddChoice;
  final ValueChanged<String> onDeleteChoice;
  final ValueChanged<String?> onSelectAnswer;

  const ObjectiveAnswerInput({
    super.key,
    required this.answerChoices,
    required this.selectedAnswer,
    required this.onAddChoice,
    required this.onDeleteChoice,
    required this.onSelectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController choiceController = TextEditingController();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: choiceController,
                decoration: const InputDecoration(
                  labelText: 'Add Answer Choices',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (choiceController.text.isNotEmpty) {
                  onAddChoice(choiceController.text);
                  choiceController.clear();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
        ...answerChoices.map(
          (choice) => ListTile(
            title: Text(choice),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDeleteChoice(choice),
            ),
          ),
        ),
      ],
    );
  }
}
