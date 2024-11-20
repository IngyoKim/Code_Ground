import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';

/// Import Tier data

/// Prepare question data
QuestionData prepareAddQuestionData({
  required String questionId,
  required String writerUid,
  required String selectedCategory,
  required String selectedType,

  /// Add question type
  required Map<String, String> codeSnippets,
  required String title,
  required String description,
  required String hint,
  required Tier tier,

  /// Change to Tier object
  List<String>? answerChoices,
  String? selectedAnswer,
  String? subjectiveAnswer,
}) {
  return QuestionData.fromMap({
    'questionId': questionId,
    'writer': writerUid,
    'category': selectedCategory,
    'questionType': selectedType,

    /// Added: Save subjective/objective type
    'updatedAt': DateTime.now().toIso8601String(),
    'title': title,
    'description': description,
    'tier': tier.name,
    'hint': hint.isEmpty ? 'No hint provided' : hint,
    'codeSnippets': codeSnippets,
    'answerChoices': answerChoices,
    'answer': subjectiveAnswer ?? selectedAnswer,
  });
}
