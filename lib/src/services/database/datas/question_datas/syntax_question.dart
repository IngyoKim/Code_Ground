import 'package:code_ground/src/services/database/datas/question_data.dart';

class SyntaxQuestion extends QuestionData {
  SyntaxQuestion({
    required super.questionId,
    required super.writer,
    required super.category,
    required super.questionType,
    required super.difficulty,
    required super.updatedAt,
    required super.title,
    required super.description,
    required super.codeSnippets, // 언어별 코드 스니펫 추가
    required super.languages,
    required super.hint,
  });

  @override
  Map<String, dynamic> toMap() {
    final baseMap = toBaseMap();
    baseMap.addAll({
      'codeSnippets': codeSnippets, // 언어별 코드 추가
    });
    return baseMap;
  }

  factory SyntaxQuestion.fromMap(Map<String, dynamic> data) {
    return SyntaxQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Syntax',
      questionType: data['questionType'] ?? 'Subjective',
      difficulty: data['difficulty'] ?? 'Easy',
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      codeSnippets:
          Map<String, String>.from(data['codeSnippets'] ?? {}), // 언어별 코드 스니펫 처리
      languages: List<String>.from(data['languages'] ?? []),
      hint: data['hint'] ?? 'No Hint',
    );
  }
}
