import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/question_operation.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionOperation _questionOperation = QuestionOperation();
  List<QuestionData> _questions = [];

  List<QuestionData> get questions => _questions;

  Future<void> fetchQuestion(String questionId) async {
    final question = await _questionOperation.readQuestionData(questionId);
    if (question != null) {
      _questions = [question];
      notifyListeners();
    }
  }

  Future<void> addQuestion(QuestionData questionData) async {
    await _questionOperation.writeQuestionData(questionData);
    await fetchQuestion(questionData.questionId); // 새로운 질문 추가 후 갱신
  }

  Future<void> updateQuestion(
      String questionId, Map<String, dynamic> updates) async {
    await _questionOperation.updateQuestionData(questionId, updates);
    await fetchQuestion(questionId);
  }
}
