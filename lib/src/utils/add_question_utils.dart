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
  Map<int, String>? sequencingSteps,
}) {
  if (title.isEmpty || description.isEmpty) {
    Fluttertoast.showToast(msg: 'Please fill in all required fields!');
    return false;
  }

  // 객관식 검증
  if (selectedType == 'Objective' &&
      (answerChoices == null ||
          answerChoices.isEmpty ||
          selectedAnswer == null)) {
    Fluttertoast.showToast(
        msg: 'Add answer choices and select a correct answer!');
    return false;
  }

  // 주관식 검증
  if (selectedType == 'Subjective' &&
      (subjectiveAnswer == null || subjectiveAnswer.isEmpty)) {
    Fluttertoast.showToast(msg: 'Provide the correct answer for Subjective!');
    return false;
  }

  // Sequencing 검증
  if (selectedCategory == 'Sequencing' &&
      (sequencingSteps == null || sequencingSteps.isEmpty)) {
    Fluttertoast.showToast(msg: 'Add steps for the sequencing question!');
    return false;
  }

  return true;
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
  Map<int, String>? sequencingSteps,
}) {
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
    'steps': sequencingSteps,
  });
}
