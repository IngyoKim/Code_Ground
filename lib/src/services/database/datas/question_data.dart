import 'package:code_ground/src/services/database/datas/tier_data.dart';
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
  final DateTime updatedAt;
  final String title;
  final String description;
  final Map<String, String> codeSnippets;
  final List<String> languages;
  final String hint;
  final dynamic answer;
  final List<String>? answerChoices;
  final Tier? tier;
  final Grade? grade;
  final int? solvers;

  QuestionData({
    required this.questionId,
    required this.writer,
    required this.category,
    required this.questionType,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.codeSnippets,
    required this.languages,
    required this.hint,
    required this.answer,
    this.answerChoices,
    this.tier,
    this.grade,
    this.solvers,
  });

  Map<String, dynamic> toBaseMap() {
    return {
      'questionId': questionId,
      'writer': writer,
      'category': category,
      'questionType': questionType,
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'codeSnippets': codeSnippets,
      'languages': languages,
      'hint': hint,
      'answer': answer,
      if (answerChoices != null) 'answerChoices': answerChoices,
      if (tier != null) 'tier': tier!.name,
      if (grade != null) 'grade': grade!.name,
      if (solvers != null) 'solvers': solvers,
    };
  }

  static QuestionData fromMap(Map<String, dynamic> data) {
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
        throw Exception('Unknown category: ${data['category']}');
    }
  }

  Map<String, dynamic> toMap();
}
