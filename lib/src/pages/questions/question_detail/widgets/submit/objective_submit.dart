import 'dart:math';
import 'package:flutter/material.dart';

class ObjectiveSubmit extends StatefulWidget {
  final List<String> answerList;
  final ValueChanged<String?> onAnswerSelected;
  final VoidCallback onSubmit;
  final String? selectedAnswer;

  const ObjectiveSubmit({
    super.key,
    required this.answerList,
    required this.onAnswerSelected,
    required this.onSubmit,
    this.selectedAnswer,
  });

  @override
  State<ObjectiveSubmit> createState() => _ObjectiveSubmitState();
}

class _ObjectiveSubmitState extends State<ObjectiveSubmit> {
  late List<String> _shuffledChoices;

  @override
  void initState() {
    super.initState();
    // 선택지를 한 번만 섞음
    _shuffledChoices = List<String>.from(widget.answerList)..shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '정답을 고르시오.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._shuffledChoices.map(
          (choice) {
            final isSelected = choice == widget.selectedAnswer;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  // 이미 선택된 답안을 누르면 선택 해제
                  widget.onAnswerSelected(isSelected ? null : choice);
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
            onPressed: widget.onSubmit, // 제출 버튼
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
}
