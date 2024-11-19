import 'dart:math';
import 'package:flutter/material.dart';

Widget buildObjectiveAnswerInput({
  required BuildContext context,
  required List<String> answerChoices,
  required ValueChanged<String?> onAnswerSelected, // String?로 변경
  required VoidCallback onSubmit,
  String? selectedAnswer, // 현재 선택된 답안
}) {
  // 선지들을 랜덤으로 섞기
  final shuffledChoices = List<String>.from(answerChoices)..shuffle(Random());

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
          final isSelected = choice == selectedAnswer; // 선택된 상태인지 확인
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
      ElevatedButton(
        onPressed: onSubmit, // 제출 버튼
        child: const Text('Submit Answer'),
      ),
    ],
  );
}
