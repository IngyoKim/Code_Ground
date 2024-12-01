import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/question_operation.dart';

class QuestionViewModel with ChangeNotifier {
  final QuestionOperation _questionOperation = QuestionOperation();
  Map<String, List<QuestionData>> _categoryQuestions = {};
  Map<String, int?> _lastCreatedAt = {};
  bool _isFetching = false;
  bool _hasMoreData = true;
  QuestionData? _selectedQuestion;

  /// 카테고리별 질문 데이터
  Map<String, List<QuestionData>> get categoryQuestions => _categoryQuestions;

  /// 로딩 상태
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
    debugPrint('[clearQuestions] Cleared all questions.');
    notifyListeners();
  }

  /// 카테고리 상태 초기화
  void resetCategoryState(String category) {
    _categoryQuestions[category] = [];
    _lastCreatedAt[category] = null;
    _hasMoreData = true;
    debugPrint('[resetCategoryState] Reset state for: $category');
    notifyListeners();
  }

  /// 특정 질문 ID로 질문 가져오기
  Future<void> fetchQuestionById(String questionId) async {
    try {
      final question = await _questionOperation.fetchQuestionById(questionId);
      if (question != null) {
        _selectedQuestion = question;
        debugPrint('[fetchQuestionById] Fetched question: $questionId');
        notifyListeners();
      } else {
        debugPrint('[fetchQuestionById] No question found for ID: $questionId');
      }
    } catch (error) {
      debugPrint('[fetchQuestionById] Error: $error');
    }
  }

  /// 특정 카테고리의 질문 불러오기 (페이징 기반)
  Future<List<QuestionData>> fetchQuestions({required String category}) async {
    if (_isFetching || !_hasMoreData) {
      debugPrint('[fetchQuestions] Fetch skipped for: $category');
      return [];
    }

    _isFetching = true;
    notifyListeners();

    try {
      final lastQuestionId = _categoryQuestions[category]?.last.questionId;
      debugPrint(
          '[fetchQuestions] Fetching for: $category, Last ID: $lastQuestionId');

      final questions = await _questionOperation.fetchQuestions(
        category,
        lastQuestionId: lastQuestionId,
        limit: 10,
      );

      if (questions.isEmpty) {
        debugPrint('[fetchQuestions] No more questions in: $category');
        _hasMoreData = false;
      } else {
        _categoryQuestions[category] ??= [];
        _categoryQuestions[category]!.addAll(questions);
        debugPrint(
            '[fetchQuestions] Total: ${_categoryQuestions[category]!.length} for $category');
      }

      notifyListeners();
      return questions;
    } catch (error) {
      debugPrint('[fetchQuestions] Error for $category: $error');
      return [];
    } finally {
      _isFetching = false;
    }
  }

  /// 질문 추가
  Future<void> addQuestion(QuestionData questionData) async {
    try {
      await _questionOperation.writeQuestionData(questionData);
      final category = questionData.category.toLowerCase();
      _categoryQuestions[category] ??= [];
      _categoryQuestions[category]!.insert(0, questionData);
      debugPrint('[addQuestion] Added question to $category');
      notifyListeners();
    } catch (error) {
      debugPrint('[addQuestion] Error: $error');
    }
  }

  /// 질문 업데이트
  Future<void> updateQuestion(QuestionData updatedQuestion) async {
    try {
      await _questionOperation.updateQuestionData(updatedQuestion);
      final category = updatedQuestion.category.toLowerCase();
      final questionIndex = _categoryQuestions[category]?.indexWhere(
        (q) => q.questionId == updatedQuestion.questionId,
      );

      if (questionIndex != null && questionIndex != -1) {
        _categoryQuestions[category]![questionIndex] = updatedQuestion;
        debugPrint('[updateQuestion] Updated question in $category');
        notifyListeners();
      }
    } catch (error) {
      debugPrint('[updateQuestion] Error: $error');
    }
  }

  /// 특정 질문 설정
  void setSelectedQuestion(QuestionData question) {
    _selectedQuestion = question;
    debugPrint('[setSelectedQuestion] Selected: ${question.questionId}');
    notifyListeners();
  }
}
