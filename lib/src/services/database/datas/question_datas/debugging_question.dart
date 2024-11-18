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
    super.answerChoices,
    super.tier,
    super.grade,
    super.solvers,
  });

  @override
  Map<String, dynamic> toMap() => super.toBaseMap();

  factory DebuggingQuestion.fromMap(Map<String, dynamic> data) {
    return DebuggingQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Debugging',
      questionType: data['questionType'] ?? '주관식',
      updatedAt: DateTime.parse(data['updatedAt']),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      codeSnippets: Map<String, String>.from(data['codeSnippets'] ?? {}),
      languages: List<String>.from(data['languages'] ?? []),
      hint: data['hint'] ?? 'No Hint',
      answer: data['answer'],
      answerChoices: data['answerChoices'] != null
          ? List<String>.from(data['answerChoices'])
          : null,
      tier: data['tier'],
      grade: data['grade'],
      solvers: data['solvers'] ?? 0,
    );
  }
}
