import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';

class SequencingQuestion extends QuestionData {
  SequencingQuestion({
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
    required List<String> super.answer, // 정답 순서 배열
    required super.tier,
    required super.grade,
    required super.solvers,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toBaseMap();
  }

  static SequencingQuestion fromMap(Map<String, dynamic> data) {
    final tier = data['tier'] != null
        ? tiers.firstWhere((t) => t.name == data['tier'])
        : null;
    final grade = (tier != null && data['grade'] != null)
        ? tier.grades.firstWhere((g) => g.name == data['grade'])
        : null;

    return SequencingQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Sequencing',
      questionType: data['questionType'] ?? '순서 맞추기',
      updatedAt:
          DateTime.parse(data['updatedAt'] ?? DateTime.now().toIso8601String()),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      codeSnippets: Map<String, String>.from(data['codeSnippets'] ?? {}),
      languages: List<String>.from(data['languages'] ?? []),
      hint: data['hint'] ?? 'No Hint',
      answer: List<String>.from(data['answer'] ?? []),
      tier: tier,
      grade: grade,
      solvers: data['solvers'] ?? 0,
    );
  }
}
