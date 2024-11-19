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
    required super.codeSnippets, // Code snippets가 정답 역할
    required super.hint,
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

    // codeSnippets 처리
    Map<String, String> codeSnippets = {};
    if (data['codeSnippets'] is List) {
      // List<String>을 Map<String, String>으로 변환
      codeSnippets = (data['codeSnippets'] as List)
          .asMap()
          .map((index, value) => MapEntry(index.toString(), value.toString()));
    } else if (data['codeSnippets'] is Map) {
      // Map<String, String> 형태
      codeSnippets = Map<String, String>.from(data['codeSnippets']);
    }

    return SequencingQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Sequencing',
      questionType: data['questionType'] ?? 'Sequencing',
      updatedAt:
          DateTime.parse(data['updatedAt'] ?? DateTime.now().toIso8601String()),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      codeSnippets: codeSnippets,
      hint: data['hint'] ?? 'No Hint',
      tier: tier,
      grade: grade,
      solvers: data['solvers'] ?? 0,
    );
  }
}
