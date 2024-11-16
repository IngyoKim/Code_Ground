import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/question_operation.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionOperation _questionOperation = QuestionOperation();
  final List<QuestionData> _questions = [];
  bool _isLoading = false;
  int _currentPage = 0; // 현재 페이지

  List<QuestionData> get questions => _questions;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 데이터를 가져오는 함수 (페이징 처리)
  Future<void> fetchQuestions(String category) async {
    if (_isLoading) return; // 중복 호출 방지

    _setLoading(true);

    try {
      debugPrint('Fetching page $_currentPage for category: $category');

      // 현재 페이지에 해당하는 10개의 데이터를 가져옴
      final startId = _currentPage * 10 + 1;
      final endId = startId + 10;

      for (int i = startId; i < endId; i++) {
        final questionId = i.toString().padLeft(5, '0'); // 00001, 00002, ...
        final question =
            await _questionOperation.readQuestionData(category, questionId);

        if (question != null) {
          _questions.add(question);
        }
      }

      _currentPage++; // 다음 페이지로 이동

      if (_questions.isEmpty) {
        debugPrint('No questions found for category: $category');
      } else {
        debugPrint('Fetched ${_questions.length} total questions');
      }
    } catch (e) {
      debugPrint('Error fetching questions: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 데이터를 초기화 (카테고리 변경 시 호출)
  void clearQuestions() {
    _questions.clear();
    _currentPage = 0;
    debugPrint('Cleared all questions');
    notifyListeners();
  }

  Future<void> addQuestion(QuestionData questionData) async {
    try {
      // questionId 생성
      String questionId =
          _questionOperation.generateQuestionId(questionData.category);

      // QuestionData 객체에 questionId를 설정
      final updatedQuestion = QuestionData.fromMap({
        ...questionData.toMap(),
        'questionId': questionId,
      });

      debugPrint('Adding question: ${updatedQuestion.toMap()}');
      await _questionOperation.writeQuestionData(updatedQuestion);

      _questions.insert(0, updatedQuestion); // 새 질문을 목록 맨 앞에 추가
      debugPrint('Question added successfully');
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding question: $e');
    }
  }
}
