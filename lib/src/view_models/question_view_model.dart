import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/question_operation.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionOperation _operation = QuestionOperation();
  final List<QuestionData> _questions = [];
  QuestionData? _selectedQuestion; // 선택된 질문
  bool _isLoading = false;
  String? _lastFetchedKey; // 마지막으로 가져온 질문의 키 (startAfter에 사용)

  List<QuestionData> get questions => _questions;
  QuestionData? get selectedQuestion => _selectedQuestion;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 질문 가져오기
  Future<void> fetchQuestions(String category, {int limit = 10}) async {
    if (_isLoading) return;

    _setLoading(true);
    try {
      final newQuestions = await _operation.fetchRecentQuestions(
        category,
        limit: limit,
        startAfter: _lastFetchedKey,
      );

      if (newQuestions.isNotEmpty) {
        _lastFetchedKey = newQuestions.last.questionId; // 마지막 키 업데이트
        _questions.addAll(newQuestions);
        notifyListeners();
      } else {
        debugPrint('No more questions available for category: $category');
      }
    } catch (e) {
      debugPrint('Error fetching questions: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 질문 초기화
  void clearQuestions() {
    _questions.clear();
    _lastFetchedKey = null;
    notifyListeners();
  }

  /// 질문 추가
  Future<void> addQuestion(QuestionData questionData) async {
    try {
      await _operation.writeQuestionData(questionData);
      _questions.insert(0, questionData); // 새 질문을 목록 맨 앞에 추가
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding question: $e');
    }
  }

  void selectQuestion(QuestionData question) {
    _selectedQuestion = question;
    notifyListeners();
  }
}
