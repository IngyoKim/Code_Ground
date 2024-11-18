import 'package:flutter/material.dart';

class AnswerChoiceWidget extends StatelessWidget {
  final List<String> answerChoices;
  final String? selectedAnswer;
  final ValueChanged<String> onAddChoice;
  final ValueChanged<String> onDeleteChoice;
  final ValueChanged<String?> onSelectAnswer;

  const AnswerChoiceWidget({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: choiceController,
                decoration:
                    const InputDecoration(labelText: 'Add Answer Choice'),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: choice,
                  groupValue: selectedAnswer,
                  onChanged: onSelectAnswer,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDeleteChoice(choice),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
