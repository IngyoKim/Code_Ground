import 'package:flutter/material.dart';

import 'package:code_ground/src/models/question_data.dart';
import 'package:code_ground/src/services/database/question_manager.dart';

class QuestionViewModel with ChangeNotifier {
  final QuestionManager _questionManager = QuestionManager();
  Map<String, List<QuestionData>> _categoryQuestions = {};
  Map<String, int?> _lastCreatedAt = {};
  bool _isFetching = false;
  bool _hasMoreData = true;
  QuestionData? _selectedQuestion;

  /// Question data by category
  Map<String, List<QuestionData>> get categoryQuestions => _categoryQuestions;

  /// Loading Status
  bool get isFetching => _isFetching;

  /// Do you have more data to import
  bool get hasMoreData => _hasMoreData;

  /// Import Selected Questions
  QuestionData? get selectedQuestion => _selectedQuestion;

  /// Iniialize all questions
  void clearQuestions() {
    _categoryQuestions = {};
    _lastCreatedAt = {};
    _isFetching = false;
    _hasMoreData = true;
    _selectedQuestion = null;
    notifyListeners();
  }

  /// catagory
  void resetCategoryState(String category) {
    _categoryQuestions[category] = [];
    _lastCreatedAt[category] = null;
    _hasMoreData = true;
    notifyListeners();
  }

  /// certain question load by ID
  Future<void> fetchQuestionById(String questionId) async {
    try {
      final question = await _questionManager.fetchQuestionById(questionId);
      if (question != null) {
        _selectedQuestion = question;
        notifyListeners();
        debugPrint('Question fetched successfully for ID: $questionId');
      } else {
        debugPrint('No question found for ID: $questionId');
      }
    } catch (error) {
      debugPrint('Error fetching question by ID: $error');
    }
  }

  /// category question load
  Future<List<QuestionData>> fetchQuestions({
    required String category,
  }) async {
    if (_isFetching || !_hasMoreData) return [];

    _isFetching = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final questions = await _questionManager.fetchQuestions(
        category,
        limit: 10,
        lastQuestionId: _categoryQuestions[category]?.last.questionId,
      );

      if (questions.isEmpty) {
        _hasMoreData = false;
      } else {
        _categoryQuestions[category] ??= [];
        _categoryQuestions[category]!.addAll(questions);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      return questions;
    } catch (error) {
      debugPrint('[fetchQuestions] Error: $error');
      return [];
    } finally {
      _isFetching = false;
    }
  }

  /// question add
  Future<void> addQuestion(QuestionData questionData) async {
    try {
      if (questionData.questionId.isEmpty) {
        final generatedId =
            await _questionManager.generateQuestionId(questionData.category);
        questionData = questionData.copyWith(questionId: generatedId);
      }

      await _questionManager.writeQuestionData(questionData);
      notifyListeners();
    } catch (error) {
      debugPrint('Error adding question: $error');
      rethrow;
    }
  }

  /// question update
  Future<void> updateQuestion(QuestionData updatedQuestion) async {
    try {
      await _questionManager.updateQuestionData(updatedQuestion);

      final category = updatedQuestion.category.toLowerCase();
      if (_categoryQuestions.containsKey(category)) {
        final questionIndex = _categoryQuestions[category]!
            .indexWhere((q) => q.questionId == updatedQuestion.questionId);

        if (questionIndex != -1) {
          _categoryQuestions[category]![questionIndex] = updatedQuestion;
          notifyListeners();
          debugPrint('Question updated successfully.');
        } else {
          debugPrint('Question not found in local cache.');
        }
      } else {
        debugPrint('Category not found in local cache.');
      }
    } catch (error) {
      debugPrint('Error updating question: $error');
    }
  }

  Future<bool> doesQuestionIdExist(String questionId) async {
    try {
      final question = await _questionManager.fetchQuestionById(questionId);
      return question != null;
    } catch (error) {
      debugPrint('[doesQuestionIdExist] Error checking question ID: $error');
      return false;
    }
  }

  /// certain question setting
  void setSelectedQuestion(QuestionData question) {
    _selectedQuestion = question;
    notifyListeners();
  }
}
