import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/question_operation.dart';

class QuestionViewModel with ChangeNotifier {
  final QuestionOperation _questionOperation = QuestionOperation();
  Map<String, List<QuestionData>> _categoryQuestions = {};
  Map<String, int> _categoryPages = {}; // 각 카테고리의 현재 페이지
  bool _isFetching = false;
  bool _hasMoreData = true;
  QuestionData? _selectedQuestion; // 선택된 질문 데이터

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
    _categoryPages = {};
    _isFetching = false;
    _hasMoreData = true;
    _selectedQuestion = null;
    notifyListeners();
  }

  /// 카테고리 상태 초기화
  void resetCategoryState(String category) {
    _categoryQuestions[category] = [];
    _categoryPages[category] = 0;
    _hasMoreData = true;
    notifyListeners();
  }

  /// 특정 카테고리의 질문 불러오기 (페이징 기반)
  Future<List<QuestionData>> fetchQuestionsByCategoryPaged({
    required String category,
    required int page,
    required int pageSize,
  }) async {
    if (_isFetching) {
      debugPrint('[fetchQuestionsByCategoryPaged] Already fetching...');
      return [];
    }
    if (!_hasMoreData) {
      debugPrint('[fetchQuestionsByCategoryPaged] No more data to fetch.');
      return [];
    }

    _isFetching = true;
    notifyListeners();

    try {
      final questions = await _questionOperation.fetchQuestions(
        category,
        page,
        pageSize,
      );

      if (!_categoryQuestions.containsKey(category)) {
        _categoryQuestions[category] = [];
      }

      if (questions.isEmpty || questions.length < pageSize) {
        debugPrint(
            '[fetchQuestionsByCategoryPaged] No more questions available.');
        _hasMoreData = false;
      } else {
        _hasMoreData = true; // 데이터가 충분하면 다시 true로 설정
      }

      _categoryQuestions[category]!.addAll(questions);
      _categoryPages[category] = page + 1;

      notifyListeners();
      return questions;
    } catch (error) {
      debugPrint('Error fetching questions for category $category: $error');
      return [];
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  /// 질문 추가
  Future<void> addQuestion(QuestionData questionData) async {
    try {
      await _questionOperation.writeQuestionData(questionData);
      final category = questionData.category.toLowerCase();
      if (!_categoryQuestions.containsKey(category)) {
        _categoryQuestions[category] = [];
      }
      _categoryQuestions[category]!.insert(0, questionData);
      notifyListeners();
    } catch (error) {
      debugPrint('Error adding question: $error');
    }
  }

  /// 특정 질문 설정
  void setSelectedQuestion(QuestionData question) {
    _selectedQuestion = question;
    notifyListeners();
  }
}
