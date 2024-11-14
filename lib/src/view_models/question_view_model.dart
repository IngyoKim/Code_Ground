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
  Future<void> fetchQuestions(
      {required String category, bool loadMore = false}) async {
    if (_isLoading) return;

    _setLoading(true);
    debugPrint(
        "Loading ${loadMore ? 'more' : 'initial'} questions for category: $category...");

    if (!loadMore) {
      _questions.clear(); // 처음 로드 시 기존 데이터를 초기화
      _currentPage = 1;
      debugPrint("Starting fresh load. Resetting currentPage to 1.");
    } else {
      debugPrint(
          "Fetching page $_currentPage with limit $_limit for category: $category");
    }

    List<QuestionData> loadedQuestions = [];
    for (int i = 0; i < _limit; i++) {
      String questionId = 'question${(_currentPage - 1) * _limit + i + 1}';
      debugPrint(
          "Attempting to load question with ID: $questionId in category: $category");
      final question =
          await _questionOperation.readQuestionData(category, questionId);
      if (question != null) {
        loadedQuestions.add(question);
        debugPrint("Loaded question: ${question.title}");
      } else {
        debugPrint(
            "No question found for ID: $questionId in category: $category, stopping fetch.");
        break;
      }
    }

    _questions.addAll(loadedQuestions);
    if (loadedQuestions.isNotEmpty) {
      _currentPage++; // 데이터가 있을 경우에만 페이지 증가
      debugPrint(
          "Page $_currentPage loaded with ${loadedQuestions.length} questions for category: $category.");
    } else {
      debugPrint("No more questions to load for category: $category.");
    }

    _setLoading(false);
    debugPrint(
        "Loading complete. Total questions loaded for category $category: ${_questions.length}");
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
  }) async {
    // QuestionOperation의 generateQuestionId 메서드를 통해 questionId 생성
    String questionId = _questionOperation.generateQuestionId();

    final questionData = QuestionData(
      questionId: questionId,
      writer: writer,
      category: category,
      updatedAt: DateTime.now(),
      title: title,
      description: description,
      answer: '',
      difficulty: difficulty,
      rewardExp: rewardExp,
      rewardScore: rewardScore,
      questionType: questionType,
      solvedCount: solvedCount,
    );

    await _questionOperation.writeQuestionData(questionData);
    _questions.add(questionData);
    notifyListeners();
    debugPrint(
      "Added new question with ID: $questionId, Title: ${questionData.title} in category: $category",
    );
  }
}
