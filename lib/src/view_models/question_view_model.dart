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

  // 첫 질문 목록 로드 및 추가 로드를 위한 메서드
  Future<void> fetchQuestions({bool loadMore = false}) async {
    if (_isLoading) return;

    _setLoading(true);
    debugPrint("Loading ${loadMore ? 'more' : 'initial'} questions...");

    if (!loadMore) {
      _questions.clear(); // 처음 로드 시 기존 데이터를 초기화
      _currentPage = 1;
      debugPrint("Starting fresh load. Resetting currentPage to 1.");
    } else {
      debugPrint("Fetching page $_currentPage with limit $_limit");
    }

    List<QuestionData> loadedQuestions = [];
    for (int i = 0; i < _limit; i++) {
      String questionId = 'question${(_currentPage - 1) * _limit + i + 1}';
      debugPrint("Attempting to load question with ID: $questionId");
      final question = await _questionOperation.readQuestionData(questionId);
      if (question != null) {
        loadedQuestions.add(question);
        debugPrint("Loaded question: ${question.title}");
      } else {
        debugPrint("No question found for ID: $questionId, stopping fetch.");
        break;
      }
    }

    _questions.addAll(loadedQuestions);
    if (loadedQuestions.isNotEmpty) {
      _currentPage++; // 데이터가 있을 경우에만 페이지 증가
      debugPrint(
          "Page $_currentPage loaded with ${loadedQuestions.length} questions.");
    } else {
      debugPrint("No more questions to load.");
    }

    _setLoading(false);
    debugPrint(
        "Loading complete. Total questions loaded: ${_questions.length}");
  }

  Future<void> addQuestion(String title, String description) async {
    final questionData = QuestionData(
      questionId: 'question${_questions.length + 1}',
      title: title,
      category: 'General',
      description: description,
      difficulty: 'Easy',
      tags: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _questionOperation.writeQuestionData(questionData);
    _questions.add(questionData);
    notifyListeners();
    debugPrint("Added new question: ${questionData.title}");
  }
}
