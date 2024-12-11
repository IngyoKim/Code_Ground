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

  /// 더 가져올 데이터가 있는지 여부
  bool get hasMoreData => _hasMoreData;

  /// 선택된 질문 가져오기
  QuestionData? get selectedQuestion => _selectedQuestion;

  /// 모든 질문 초기화
  void clearQuestions() {
    _categoryQuestions = {};
    _lastCreatedAt = {};
    _isFetching = false;
    _hasMoreData = true;
    _selectedQuestion = null;
    notifyListeners();
  }

  /// 카테고리 상태 초기화
  void resetCategoryState(String category) {
    _categoryQuestions[category] = [];
    _lastCreatedAt[category] = null;
    _hasMoreData = true;
    notifyListeners();
  }

  /// 특정 질문 ID로 질문 가져오기
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

  /// 특정 카테고리의 질문 불러오기 (페이징 기반)
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

  /// 질문 추가
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

  /// 질문 업데이트
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

  /// 특정 질문 설정
  void setSelectedQuestion(QuestionData question) {
    _selectedQuestion = question;
    notifyListeners();
  }
}
