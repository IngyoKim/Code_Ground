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
  int rewardExp;
  DateTime updatedAt;
  String title;
  String description;
  String answer;

  QuestionData({
    required this.questionId,
    required this.writer,
    required this.category,
    required this.questionType,
    required this.rewardExp,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.answer,
  });

  // 공통 필드를 포함하는 기본 Map 변환
  Map<String, dynamic> toBaseMap() {
    return {
      'questionId': questionId,
      'writer': writer,
      'category': category,
      'questionType': questionType,
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'rewardExp': rewardExp,
      'answer': answer,
    };
  }

  // 서브클래스에서 호출할 공통 필드 초기화 메서드
  static T fromMapBase<T extends QuestionData>(
      Map<String, dynamic> data, T Function(Map<String, dynamic>) create) {
    return create(data);
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
        throw Exception("Unknown category: ${data['category']}");
    }
  }

  Map<String, dynamic> toMap(); // 각 서브클래스에서 구현
}
