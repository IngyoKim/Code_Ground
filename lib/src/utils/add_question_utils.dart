import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

/// 필수 필드 검증
bool validateFields({
  required BuildContext context,
  required String title,
  required String description,
  required String selectedCategory,
  required String selectedType,
  List<String>? answerChoices,
  String? selectedAnswer,
  String? subjectiveAnswer,
  Map<int, String>? sequencingSteps, // 추가
}) {
  if (title.isEmpty || description.isEmpty) {
    Fluttertoast.showToast(msg: 'Please fill in all required fields!');
    return false;
  }

  if (selectedCategory == 'Sequencing') {
    if (sequencingSteps == null || sequencingSteps.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please add steps for the sequencing question!');
      return false;
    }
    return true;
  }

  if (selectedType == 'Objective') {
    if (answerChoices == null ||
        answerChoices.isEmpty ||
        selectedAnswer == null) {
      Fluttertoast.showToast(
          msg: 'Please provide choices and select an answer!');
      return false;
    }
  }

  if (selectedType == 'Subjective' &&
      (subjectiveAnswer == null || subjectiveAnswer.isEmpty)) {
    Fluttertoast.showToast(
        msg: 'Please provide an answer for subjective type!');
    return false;
  }

  return true; // 모든 검증 통과
}

/// 질문 데이터 준비
QuestionData prepareAddQuestionData({
  required String questionId,
  required String writerUid,
  required String selectedCategory,
  required String selectedType, // Question type 추가
  required Map<String, String> codeSnippets,
  required String selectedLanguage,
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
    'languages': [selectedLanguage],
    'answerChoices': answerChoices,
    'selectedAnswer': selectedAnswer,
    'subjectiveAnswer': subjectiveAnswer,
  });
}
