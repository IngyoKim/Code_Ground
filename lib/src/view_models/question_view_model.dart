import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/question_operation.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionOperation _questionOperation = QuestionOperation();
  final List<QuestionData> _questions = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _limit = 15;

  List<QuestionData> get questions => _questions;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchQuestions({
    required String category,
    bool loadMore = false,
  }) async {
    if (_isLoading) return;

    _setLoading(true);
    if (!loadMore) {
      _questions.clear();
      _currentPage = 1;
    }

    List<QuestionData> loadedQuestions = [];
    for (int i = 0; i < _limit; i++) {
      String questionId = 'question${(_currentPage - 1) * _limit + i + 1}';
      final question =
          await _questionOperation.readQuestionData(category, questionId);
      if (question != null) {
        loadedQuestions.add(question);
      } else {
        break;
      }
    }

    _questions.addAll(loadedQuestions);
    if (loadedQuestions.isNotEmpty) _currentPage++;

    _setLoading(false);
  }

  Future<void> addQuestion({
    required String title,
    required String description,
    required String writer,
    required String category,
    required String difficulty,
    int rewardExp = 0,
    int rewardScore = 0,
    String questionType = 'Subjective',
    int solvedCount = 0,
    int step = 1,
    String hint = '',
    List<String> answerSequence = const [],
  }) async {
    String questionId = _questionOperation.generateQuestionId();
    DateTime updatedAt = DateTime.now();

    // QuestionData.fromCategory를 이용하여 적절한 서브클래스 인스턴스를 생성
    QuestionData questionData = QuestionData.fromMap({
      'questionId': questionId,
      'writer': writer,
      'category': category,
      'questionType': questionType,
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'rewardExp': rewardExp,
      'rewardScore': rewardScore,
      'difficulty': difficulty,
      'solvedCount': solvedCount,
      'step': step,
      'hint': hint,
      'answerSequence': answerSequence,
    });

    await _questionOperation.writeQuestionData(questionData);
    _questions.add(questionData);
    notifyListeners();
  }
}
