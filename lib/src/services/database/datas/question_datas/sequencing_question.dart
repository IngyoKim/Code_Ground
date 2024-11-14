import 'package:code_ground/src/services/database/datas/question_data.dart';

class SequencingQuestion extends QuestionData {
  final int rewardScore;
  final String difficulty;
  final List<String> answerSequence;
  final int solvedCount;

  SequencingQuestion({
    required super.questionId,
    required super.writer,
    required super.category,
    required super.updatedAt,
    required super.title,
    required super.description,
    required super.rewardExp,
    required super.questionType,
    required super.answer,
    required this.rewardScore,
    required this.difficulty,
    required this.answerSequence,
    required this.solvedCount,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...toBaseMap(),
      'rewardScore': rewardScore,
      'difficulty': difficulty,
      'answerSequence': answerSequence,
      'solvedCount': solvedCount,
      'answer': answer,
    };
  }

  factory SequencingQuestion.fromMap(Map<String, dynamic> data) {
    return QuestionData.fromMapBase(data, (baseData) {
      return SequencingQuestion(
        questionId: baseData['questionId'] ?? 'unknown_id',
        writer: baseData['writer'] ?? 'unknown_writer',
        category: baseData['category'] ?? 'Sequencing',
        updatedAt: baseData['updatedAt'] != null
            ? DateTime.parse(baseData['updatedAt'])
            : DateTime.now(),
        title: baseData['title'] ?? 'No Title',
        description: baseData['description'] ?? 'No Description',
        rewardExp: baseData['rewardExp'] ?? 0,
        questionType: baseData['questionType'] ?? 'Objective',
        answer: baseData['answer'] ?? '',
        rewardScore: baseData['rewardScore'] ?? 0,
        difficulty: baseData['difficulty'] ?? 'Easy',
        answerSequence: List<String>.from(baseData['answerSequence'] ?? []),
        solvedCount: baseData['solvedCount'] ?? 0,
      );
    });
  }
}
