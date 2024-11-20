import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart'; // Tier 데이터 import

/// 질문 데이터 준비
QuestionData prepareAddQuestionData({
  required String questionId,
  required String writerUid,
  required String selectedCategory,
  required String selectedType, // Question type 추가
  required Map<String, String> codeSnippets,
  required String title,
  required String description,
  required String hint,
  required Tier tier, // Tier 객체로 변경
  List<String>? answerChoices,
  String? selectedAnswer,
  String? subjectiveAnswer,
}) {
  return QuestionData.fromMap({
    'questionId': questionId,
    'writer': writerUid,
    'category': selectedCategory,
    'questionType': selectedType, // 추가: 주관식/객관식 저장
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
