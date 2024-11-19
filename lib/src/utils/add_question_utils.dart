import 'package:code_ground/src/services/database/datas/question_data.dart';

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
  List<String>? answerChoices,
  String? selectedAnswer,
  String? subjectiveAnswer,
  Map<int, String>? sequencingSteps, // Sequencing steps 추가
}) {
  // Sequencing의 경우 codeSnippets에 steps를 추가
  if (selectedCategory == 'Sequencing' && sequencingSteps != null) {
    codeSnippets['SequencingSteps'] = sequencingSteps.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('|'); // 키-값으로 문자열 변환
  }

  return QuestionData.fromMap({
    'questionId': questionId,
    'writer': writerUid,
    'category': selectedCategory,
    'questionType': selectedType, // 추가: 주관식/객관식 저장
    'updatedAt': DateTime.now().toIso8601String(),
    'title': title,
    'description': description,
    'hint': hint.isEmpty ? 'No hint provided' : hint,
    'codeSnippets': codeSnippets,
    'answerChoices': answerChoices,
    'answer': subjectiveAnswer ?? selectedAnswer, // answer는 주관식 또는 객관식
  });
}
