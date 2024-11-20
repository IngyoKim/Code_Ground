import 'package:code_ground/src/services/database/datas/question_data.dart';

class SyntaxQuestion extends QuestionData {
  SyntaxQuestion({
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
    required super.tier,
    super.answerChoices,
  });

  @override
  Map<String, dynamic> toMap() => super.toBaseMap();

  factory SyntaxQuestion.fromMap(Map<String, dynamic> data) {
    return SyntaxQuestion(
      questionId: data['questionId'] ?? 'unknown_id',
      writer: data['writer'] ?? 'unknown_writer',
      category: data['category'] ?? 'Syntax',
      questionType: data['questionType'] ?? 'subjective',
      updatedAt: DateTime.parse(data['updatedAt']),
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      codeSnippets: Map<String, String>.from(data['codeSnippets'] ?? {}),
      hint: data['hint'] ?? 'No Hint',
      answer: data['answer'],
      tier: data['tier'],
      answerChoices: data['answerChoices'] != null
          ? List<String>.from(data['answerChoices'])
          : null,
    );
  }
}
