import 'package:code_ground/src/services/database/datas/question_datas/syntax_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/debugging_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/output_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/blank_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/sequencing_question.dart';
import 'package:flutter/material.dart';

abstract class QuestionData {
  final String questionId;
  final String writer;
  final String category;
  final String questionType;
  final String difficulty;
  final DateTime updatedAt;
  final String title;
  final String description;
  final List<String> languages; // 여러 언어 지원
  final String hint; // 힌트 필드 추가

  QuestionData({
    required this.questionId,
    required this.writer,
    required this.category,
    required this.questionType,
    required this.difficulty,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.languages,
    required this.hint,
  });

  Map<String, dynamic> toBaseMap() {
    return {
      'writer': writer,
      'category': category,
      'questionType': questionType,
      'difficulty': difficulty,
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'languages': languages,
      'hint': hint,
    };
  }

  static QuestionData fromMap(Map<String, dynamic> data) {
    debugPrint('Converting data to QuestionData: $data');
    switch (data['category']) {
      case 'Syntax':
        return SyntaxQuestion.fromMap(data);
      case 'Debugging':
        return DebuggingQuestion.fromMap(data);
      case 'Output':
        return OutputQuestion.fromMap(data);
      case 'Blank':
        return BlankQuestion.fromMap(data);
      case 'Sequencing':
        return SequencingQuestion.fromMap(data);
      default:
        throw Exception("Unknown category: ${data['category']}");
    }
  }

  Map<String, dynamic> toMap();
}
