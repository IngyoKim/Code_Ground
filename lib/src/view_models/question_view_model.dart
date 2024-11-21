import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/question_operation.dart';

class QuestionViewModel with ChangeNotifier {
  final QuestionOperation _questionOperation = QuestionOperation();
  Map<String, List<QuestionData>> _categoryQuestions = {};
  QuestionData? _selectedQuestion;

  /// 카테고리별 질문 데이터
  Map<String, List<QuestionData>> get categoryQuestions => _categoryQuestions;

  /// 선택된 질문
  QuestionData? get selectedQuestion => _selectedQuestion;

  /// 모든 질문 초기화
  void clearQuestions() {
    _categoryQuestions = {};
    _selectedQuestion = null;
    notifyListeners();
  }

  /// 특정 카테고리의 질문 불러오기
  Future<void> fetchQuestionsByCategory(String category) async {
    try {
      final questions =
          await _questionOperation.fetchQuestionsByCategory(category);
      _categoryQuestions[category] = questions;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching questions for category $category: $e');
    }
  }

  /// 모든 카테고리의 질문 불러오기
  Future<void> fetchAllQuestions() async {
    try {
      final categories = [
        'syntax',
        'debugging',
        'output',
        'blank',
        'sequencing'
      ];
      for (final category in categories) {
        await fetchQuestionsByCategory(category);
      }
    } catch (e) {
      debugPrint('Error fetching all questions: $e');
    }
  }

  /// 특정 질문 불러오기
  Future<void> fetchQuestionById(String category, String questionId) async {
    try {
      _selectedQuestion =
          await _questionOperation.readQuestionData(category, questionId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching question by ID: $e');
    }
  }

  /// 질문 추가
  Future<void> addQuestion(QuestionData questionData) async {
    try {
      await _questionOperation.writeQuestionData(questionData);
      final category = questionData.category.toLowerCase();
      _categoryQuestions[category] = [
        if (_categoryQuestions[category] != null)
          ..._categoryQuestions[category]!,
        questionData
      ];
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding question: $e');
    }
  }

  /// 질문 업데이트
  Future<void> updateQuestion(
      String category, String questionId, Map<String, dynamic> updates) async {
    try {
      await _questionOperation.updateQuestionData(
          category, questionId, updates);

      final questions = _categoryQuestions[category.toLowerCase()] ?? [];
      final index = questions.indexWhere((q) => q.questionId == questionId);
      if (index != -1) {
        final updatedQuestion =
            await _questionOperation.readQuestionData(category, questionId);
        if (updatedQuestion != null) {
          questions[index] = updatedQuestion;
          _categoryQuestions[category.toLowerCase()] = questions;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating question: $e');
    }
  }

  /// 선택된 질문 설정
  void setSelectedQuestion(QuestionData question) {
    _selectedQuestion = question;
    notifyListeners();
  }
}
