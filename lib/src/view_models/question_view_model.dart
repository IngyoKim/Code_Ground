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

  /// 로딩 상태 설정
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 질문 목록 가져오기
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
      _questions.insert(0, questionData);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding question: $e');
    }
  }

  /// 질문 선택
  void selectQuestion(QuestionData question) {
    _selectedQuestion = question;
    notifyListeners();
  }

  /// solvers 업데이트
  Future<void> addSolver(String category, String questionId) async {
    try {
      final questionIndex =
          _questions.indexWhere((q) => q.questionId == questionId);

      if (questionIndex != -1) {
        final question = _questions[questionIndex];
        final currentSolvers = question.solvers ?? 0; // solvers 기본값 0 처리
        final updatedSolvers = currentSolvers + 1;

        await _operation.updateQuestionData(
          category,
          questionId,
          {'solvers': updatedSolvers},
        );

        // 기존 QuestionData를 업데이트된 solvers로 교체
        final updatedQuestion = QuestionData.fromMap({
          ...question.toMap(),
          'solvers': updatedSolvers,
        });

        _questions[questionIndex] = updatedQuestion;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating solvers: $e');
    }
  }
}
