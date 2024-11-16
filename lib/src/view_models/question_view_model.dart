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

  /// Fetch questions from the database
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
      String questionId =
          '${_questionOperation.generateQuestionId(category)}${(_currentPage - 1) * _limit + i + 1}';
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

  /// Add a new question to the database
  Future<void> addQuestion({
    required String title,
    required String description,
    required String writer,
    required String category,
    required String difficulty,
    required String questionType,
    required String hint,
    required List<String> languages,
    int step = 1,
    List<String> answerSequence = const [],
  }) async {
    String questionId = _questionOperation.generateQuestionId(category);
    DateTime updatedAt = DateTime.now();

    // Create an instance of the appropriate subclass
    QuestionData questionData = QuestionData.fromMap({
      'questionId': questionId,
      'writer': writer,
      'category': category,
      'questionType': questionType,
      'difficulty': difficulty,
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'description': description,
      'languages': languages, // SyntaxQuestion도 리스트로 통합
      'hint': hint,
      'step': step,
      'answerSequence': answerSequence,
    });

    await _questionOperation.writeQuestionData(questionData);
    _questions.add(questionData);
    notifyListeners();
  }
}
