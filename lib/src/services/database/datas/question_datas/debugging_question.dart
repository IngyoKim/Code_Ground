import 'package:code_ground/src/services/database/datas/question_data.dart';

class DebuggingQuestion extends QuestionData {
  final String hint;
  final int rewardScore;
  final String difficulty;

  DebuggingQuestion({
    required super.questionId,
    required super.writer,
    required super.category,
    required super.updatedAt,
    required super.title,
    required super.description,
    required super.rewardExp,
    required super.questionType,
    required super.answer,
    required this.hint,
    required this.rewardScore,
    required this.difficulty,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...toBaseMap(),
      'hint': hint,
      'rewardScore': rewardScore,
      'difficulty': difficulty,
      'answer': answer,
    };
  }

  factory DebuggingQuestion.fromMap(Map<String, dynamic> data) {
    return QuestionData.fromMapBase(data, (baseData) {
      return DebuggingQuestion(
        questionId: baseData['questionId'] ?? 'unknown_id',
        writer: baseData['writer'] ?? 'unknown_writer',
        category: baseData['category'] ?? 'Debugging',
        updatedAt: baseData['updatedAt'] != null
            ? DateTime.parse(baseData['updatedAt'])
            : DateTime.now(),
        title: baseData['title'] ?? 'No Title',
        description: baseData['description'] ?? 'No Description',
        rewardExp: baseData['rewardExp'] ?? 0,
        questionType: baseData['questionType'] ?? 'Subjective',
        answer: baseData['answer'] ?? '',
        hint: baseData['hint'] ?? 'No Hint',
        rewardScore: baseData['rewardScore'] ?? 0,
        difficulty: baseData['difficulty'] ?? 'Easy',
      );
    });
  }
}
