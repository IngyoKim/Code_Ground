import 'package:code_ground/src/services/database/datas/question_data.dart';

class BlankQuestion extends QuestionData {
  BlankQuestion({
    required super.questionId,
    required super.writer,
    required super.category,
    required super.questionType,
    required super.difficulty,
    required super.updatedAt,
    required super.title,
    required super.description,
    required super.codeSnippets,
    required super.languages,
    required super.hint,
  });

  @override
  Map<String, dynamic> toMap() {
    final baseMap = toBaseMap();
    baseMap.addAll({
      'codeSnippets': codeSnippets,
    });
    return baseMap;
  }

  factory BlankQuestion.fromMap(Map<String, dynamic> data) {
    return BlankQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Blank',
      questionType: data['questionType'] ?? 'Objective',
      difficulty: data['difficulty'] ?? 'Easy',
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      codeSnippets: Map<String, String>.from(data['codeSnippets'] ?? {}),
      languages: List<String>.from(data['languages'] ?? []),
      hint: data['hint'] ?? 'No Hint',
    );
  }
}
