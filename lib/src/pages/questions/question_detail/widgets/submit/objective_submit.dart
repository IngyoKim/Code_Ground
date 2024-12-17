import 'dart:math';
import 'package:flutter/material.dart';

Widget objectiveSubmit({
  required BuildContext context,
  required List<String> answerList,
  required ValueChanged<String?> onAnswerSelected,
  required VoidCallback onSubmit,
  String? selectedAnswer,
}) {
  // 선지들을 랜덤으로 섞기
  final shuffledChoices = List<String>.from(answerList)..shuffle(Random());

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        '정답을 고르시오.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...shuffledChoices.map(
        (choice) {
          final isSelected = choice == selectedAnswer;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ElevatedButton(
              onPressed: () {
                // 이미 선택된 답안을 누르면 선택 해제
                onAnswerSelected(isSelected ? null : choice);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.green : Colors.grey[700],
                foregroundColor: Colors.white,
              ),
              child: Text(choice),
            ),
          );
        },
      ),
      const SizedBox(height: 16),
      Center(
        child: ElevatedButton(
          onPressed: onSubmit, // 제출 버튼
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
          ),
          child: const Text(
            'Submit Answer',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    ],
  );
}
