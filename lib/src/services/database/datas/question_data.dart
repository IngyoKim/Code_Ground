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
  final String hint;
  final dynamic answer; // 모든 서브클래스에 공통이 아니므로 `SequencingQuestion`에서 사용하지 않음
  final List<String>? answerChoices;
  final String? tier;
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
    required this.hint,
    this.answer, // `SequencingQuestion`에서는 `null`로 사용 가능
    this.answerChoices,
    this.tier,
    this.solvers,
  });

  /// 공통 데이터를 Map으로 변환
  Map<String, dynamic> toBaseMap() {
    return {
      'questionId': questionId,
      'writer': writer,
      'category': category,
      'questionType': questionType,
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'codeSnippets': codeSnippets, // Sequencing에서 이 필드를 통해 정답 관리
      'hint': hint,
      'tier': tier,

      if (answer != null) 'answer': answer, // SequencingQuestion에서는 사용되지 않음
      if (answerChoices != null) 'answerChoices': answerChoices,

      if (solvers != null) 'solvers': solvers,
    };
  }

  /// 데이터를 Map에서 적절한 서브클래스로 변환
  factory QuestionData.fromMap(Map<String, dynamic> data) {
    final category = data['category'] as String? ?? '';

    switch (category) {
      case 'Syntax':
        return SyntaxQuestion.fromMap(data);
      case 'Debugging':
        return DebuggingQuestion.fromMap(data);
      case 'Output':
        return OutputQuestion.fromMap(data);
      case 'Blank':
        return BlankQuestion.fromMap(data);
      case 'Sequencing':
        return SequencingQuestion.fromMap(data); // SequencingQuestion로 매핑
      default:
        throw Exception('Unknown or missing category: $category');
    }
  }

  /// 서브클래스에서 구현해야 할 Map 변환
  Map<String, dynamic> toMap();
}
