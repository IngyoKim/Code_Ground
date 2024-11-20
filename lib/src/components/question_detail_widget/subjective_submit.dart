// 답 입력을 위한 함수형 위젯
import 'package:flutter/material.dart';

Widget subjectiveSubmit({
  required BuildContext context,
  required TextEditingController controller,
  required ValueChanged<String> onAnswerSubmitted,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Your Answer:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Type your answer here...',
          border: OutlineInputBorder(),
        ),
        maxLines: 1,
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () => onAnswerSubmitted(controller.text),
        child: const Text('Submit Answer'),
      ),
    ],
  );
}
