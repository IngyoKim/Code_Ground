import 'package:code_ground/src/services/database/datas/question_data.dart';

class SyntaxQuestion extends QuestionData {
  final int step;

  SyntaxQuestion({
    required super.questionId,
    required super.writer,
    required super.category,
    required super.updatedAt,
    required super.title,
    required super.description,
    required super.rewardExp,
    required super.questionType,
    required super.answer,
    required this.step,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...toBaseMap(),
      'step': step,
    };
  }

  factory SyntaxQuestion.fromMap(Map<String, dynamic> data) {
    return QuestionData.fromMapBase(data, (baseData) {
      return SyntaxQuestion(
        questionId: baseData['questionId'] ?? 'unknown_id',
        writer: baseData['writer'] ?? 'unknown_writer',
        category: baseData['category'] ?? 'Syntax',
        updatedAt: baseData['updatedAt'] != null
            ? DateTime.parse(baseData['updatedAt'])
            : DateTime.now(),
        title: baseData['title'] ?? 'No Title',
        description: baseData['description'] ?? 'No Description',
        rewardExp: baseData['rewardExp'] ?? 0,
        questionType: baseData['questionType'] ?? 'Subjective',
        answer: baseData['answer'] ?? '',
        step: baseData['step'] ?? 1,
      );
    });
  }
}
