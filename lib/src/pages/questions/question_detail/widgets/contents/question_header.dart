import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:code_ground/src/models/user_data.dart';
import 'package:code_ground/src/models/question_data.dart';

Widget questionHeader(QuestionData question, UserData? writer) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question.title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      Text(
          "${writer?.nickname ?? 'unknown'} / ${DateFormat('yyyy-MM-dd HH:mm:ss').format(question.updatedAt)}"),
      const SizedBox(height: 16),
      Text(
        question.description,
        style: const TextStyle(fontSize: 16),
      ),
    ],
  );
}
