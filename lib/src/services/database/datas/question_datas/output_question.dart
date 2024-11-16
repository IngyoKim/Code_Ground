import 'package:code_ground/src/services/database/datas/question_data.dart';

class OutputQuestion extends QuestionData {
  OutputQuestion({
    required super.questionId,
    required super.writer,
    required super.category,
    required super.questionType,
    required super.difficulty,
    required super.updatedAt,
    required super.title,
    required super.description,
    required super.languages,
    required super.hint,
  });

  @override
  Map<String, dynamic> toMap() {
    return toBaseMap();
  }

  factory OutputQuestion.fromMap(Map<String, dynamic> data) {
    return OutputQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Output',
      questionType: data['questionType'] ?? 'Subjective',
      difficulty: data['difficulty'] ?? 'Easy',
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      languages: List<String>.from(data['languages'] ?? []),
      hint: data['hint'] ?? 'No Hint',
    );
  }
}
