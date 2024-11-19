import 'package:code_ground/src/services/database/datas/question_data.dart';

class BlankQuestion extends QuestionData {
  BlankQuestion({
    required super.questionId,
    required super.writer,
    required super.category,
    required super.questionType,
    required super.updatedAt,
    required super.title,
    required super.description,
    required super.codeSnippets,
    required super.hint,
    required super.answer,
    required super.answerChoices,
    super.tier,
    super.grade,
    super.solvers,
  });

  @override
  Map<String, dynamic> toMap() => super.toBaseMap();

  factory BlankQuestion.fromMap(Map<String, dynamic> data) {
    return BlankQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Blank',
      questionType: data['questionType'] ?? '객관식',
      updatedAt: DateTime.parse(data['updatedAt']),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      codeSnippets: Map<String, String>.from(data['codeSnippets'] ?? {}),
      hint: data['hint'] ?? 'No Hint',
      answer: data['answer'],
      answerChoices: List<String>.from(data['answerChoices'] ?? []),
      tier: data['tier'],
      grade: data['grade'],
      solvers: data['solvers'] ?? 0,
    );
  }
}
