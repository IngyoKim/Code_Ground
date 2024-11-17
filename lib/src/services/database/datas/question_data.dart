import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_datas/syntax_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/debugging_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/output_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/blank_question.dart';
import 'package:code_ground/src/services/database/datas/question_datas/sequencing_question.dart';

abstract class QuestionData {
  final String questionId;
  final String writer;
  final String category;
  final String questionType;
  final String difficulty;
  final DateTime updatedAt;
  final String title;
  final String description; // 설명은 단일 필드로 유지
  final Map<String, String> codeSnippets; // 언어별 코드 스니펫
  final List<String> languages; // 지원하는 프로그래밍 언어
  final String hint; // 힌트 필드

  QuestionData({
    required this.questionId,
    required this.writer,
    required this.category,
    required this.questionType,
    required this.difficulty,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.codeSnippets,
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
      'codeSnippets': codeSnippets,
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
