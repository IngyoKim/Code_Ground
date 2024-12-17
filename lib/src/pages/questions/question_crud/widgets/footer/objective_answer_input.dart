import 'package:flutter/material.dart';

class ObjectiveAnswerInput extends StatelessWidget {
  final List<String> answerChoices; // 객관식 답안 리스트
  final String? selectedAnswer; // 선택된 답안
  final ValueChanged<String> onAddChoice; // 답안 추가 콜백
  final ValueChanged<String> onDeleteChoice; // 답안 삭제 콜백
  final ValueChanged<String?> onSelectAnswer; // 답안 선택 콜백

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: choiceController,
                decoration: const InputDecoration(
                  labelText: 'Add Answer List',
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Answer List:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...answerChoices.map(
          (choice) => ListTile(
            title: Text(choice),
            leading: Radio<String>(
              value: choice,
              groupValue: selectedAnswer,
              onChanged: (value) {
                onSelectAnswer(value);
              },
            ),
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
