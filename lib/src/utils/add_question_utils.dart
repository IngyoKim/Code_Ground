import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

/// Validate fields
bool validateFields({
  required String title,
  required String description,
  required String selectedType,
  required List<String> answerChoices,
  required String? selectedAnswer,
  required String subjectiveAnswer,
}) {
  if (title.isEmpty || description.isEmpty) {
    Fluttertoast.showToast(msg: 'Please fill in all required fields!');
    return false;
  }
  if (selectedType == 'Objective' &&
      (answerChoices.isEmpty || selectedAnswer == null)) {
    Fluttertoast.showToast(
        msg: 'Add answer choices and select a correct answer!');
    return false;
  }
  if (selectedType == 'Subjective' && subjectiveAnswer.isEmpty) {
    Fluttertoast.showToast(msg: 'Please provide the answer for Subjective!');
    return false;
  }
  return true;
}

/// Prepare question data
QuestionData prepareQuestionData({
  required String questionId,
  required String writerUid,
  required String selectedCategory,
  required String selectedType,
  required Map<String, String> codeSnippets,
  required String selectedLanguage,
  required String title,
  required String description,
  required String hint,
  required String? selectedAnswer,
  required List<String> answerChoices,
  required String subjectiveAnswer,
  required TextEditingController snippetController,
}) {
  // Add default snippet for Syntax
  if (selectedCategory == 'Syntax') {
    codeSnippets.clear();
    codeSnippets[selectedLanguage] = snippetController.text;
  }

  return QuestionData.fromMap({
    'questionId': questionId,
    'writer': writerUid,
    'category': selectedCategory,
    'questionType': selectedType,
    'updatedAt': DateTime.now().toIso8601String(),
    'title': title,
    'description': description,
    'codeSnippets': codeSnippets,
    'languages': codeSnippets.keys.toList(),
    'hint': hint.isEmpty ? 'No hint provided' : hint,
    'answer': selectedType == 'Subjective' ? subjectiveAnswer : selectedAnswer,
    'answerChoices': selectedType == 'Objective' ? answerChoices : null,
  });
}
