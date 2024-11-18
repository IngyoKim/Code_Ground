import 'package:code_ground/src/services/database/datas/tier_data.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

class DebuggingQuestion extends QuestionData {
  DebuggingQuestion({
    required super.questionId,
    required super.writer,
    required super.category,
    required super.questionType,
    required super.updatedAt,
    required super.title,
    required super.description,
    required super.codeSnippets,
    required super.languages,
    required super.hint,
    required super.answer,
    required super.tier,
    required super.grade,
    required super.solvers,
    super.answerChoices,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toBaseMap();
  }

  static DebuggingQuestion fromMap(Map<String, dynamic> data) {
    final tier = data['tier'] != null
        ? tiers.firstWhere((t) => t.name == data['tier'])
        : null;
    final grade = (tier != null && data['grade'] != null)
        ? tier.grades.firstWhere((g) => g.name == data['grade'])
        : null;

    return DebuggingQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Debugging',
      questionType: data['questionType'] ?? '주관식',
      updatedAt:
          DateTime.parse(data['updatedAt'] ?? DateTime.now().toIso8601String()),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      codeSnippets: Map<String, String>.from(data['codeSnippets'] ?? {}),
      languages: List<String>.from(data['languages'] ?? []),
      hint: data['hint'] ?? 'No Hint',
      answer: data['answer'],
      answerChoices: data['answerChoices'] != null
          ? List<String>.from(data['answerChoices'])
          : null,
      tier: tier,
      grade: grade,
      solvers: data['solvers'] ?? 0,
    );
  }
}
