import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/question_operation.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionOperation _operation = QuestionOperation();
  final List<QuestionData> _questions = [];
  bool _isLoading = false;
  String? _lastFetchedKey;
  QuestionData? _selectedQuestion;

  List<QuestionData> get questions => _questions;
  bool get isLoading => _isLoading;
  QuestionData? get selectedQuestion => _selectedQuestion;

  /// Updates the loading state.
  void _setLoading(bool loading) {
    _isLoading = loading;
    debugPrint('Loading state updated: $_isLoading');
    notifyListeners();
  }

  /// Fetches the list of questions.
  Future<void> fetchQuestions(String category, {int limit = 10}) async {
    if (_isLoading) {
      debugPrint('Already loading. Skipping fetchQuestions.');
      return;
    }

    debugPrint('Fetching questions for category: $category');
    _setLoading(true);
    try {
      final newQuestions = await _operation.fetchRecentQuestions(
        category,
        limit: limit,
        startAfter: _lastFetchedKey,
      );

      debugPrint('Fetched ${newQuestions.length} questions.');
      if (newQuestions.isNotEmpty) {
        _lastFetchedKey = newQuestions.last.questionId;
        debugPrint('Last fetched key updated: $_lastFetchedKey');
        _questions.addAll(newQuestions);
        notifyListeners();
      } else {
        debugPrint('No new questions fetched.');
      }
    } catch (e) {
      debugPrint('Error fetching questions: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Clears the list of questions and resets the last fetched key.
  void clearQuestions() {
    debugPrint('Clearing questions and resetting last fetched key.');
    _questions.clear();
    _lastFetchedKey = null;
    notifyListeners();
  }

  /// Updates the selected question.
  void selectQuestion(QuestionData question) {
    _selectedQuestion = question;
    debugPrint('Selected question updated: ${question.questionId}');
    notifyListeners();
  }

  Future<void> addQuestion(QuestionData questionData) async {
    debugPrint('Adding question: ${questionData.questionId}');
    try {
      await _operation.writeQuestionData(questionData);
      _questions.insert(0, questionData);
      debugPrint('Question added successfully.');
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding question: $e');
    }
  }

  /// Updates the solvers for a question.
  Future<void> addSolver(String category, String questionId) async {
    debugPrint('Updating solvers for question: $questionId');
    try {
      final questionIndex =
          _questions.indexWhere((q) => q.questionId == questionId);

      if (questionIndex != -1) {
        final question = _questions[questionIndex];
        final updatedSolvers = (question.solvers ?? 0) + 1;

        debugPrint(
            'Current solvers: ${question.solvers}, updated solvers: $updatedSolvers');
        await _operation.updateQuestionData(category, questionId, {
          'solvers': updatedSolvers,
        });

        final updatedQuestion = QuestionData.fromMap({
          ...question.toMap(),
          'solvers': updatedSolvers,
        });

        _questions[questionIndex] = updatedQuestion;
        debugPrint('Solvers updated successfully for question: $questionId');
        notifyListeners();
      } else {
        debugPrint('Question not found in the list: $questionId');
      }
    } catch (e) {
      debugPrint('Error updating solvers: $e');
    }
  }
}
