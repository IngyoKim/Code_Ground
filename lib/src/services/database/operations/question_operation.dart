import 'package:flutter/foundation.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:code_ground/src/services/database/datas/question_id_generator.dart';

const basePath = 'Questions';

class QuestionOperation {
  final DatabaseService _dbService = DatabaseService();

  /// 질문 ID로 질문 가져오기
  Future<QuestionData?> fetchQuestionById(String questionId) async {
    try {
      final category = QuestionIdGenerator.getCategoryFromId(questionId);
      if (category == null) {
        debugPrint('[fetchQuestionById] Invalid question ID: $questionId');
        return null;
      }

      final path = '$basePath/${category.toLowerCase()}/$questionId';
      final data = await _dbService.readDB(path);
      if (data != null) {
        return QuestionData.fromJson(Map<String, dynamic>.from(data));
      } else {
        debugPrint(
            '[fetchQuestionById] No data found for question ID: $questionId');
        return null;
      }
    } catch (error) {
      debugPrint('[fetchQuestionById] Error fetching question: $error');
      return null;
    }
  }

  /// 카테고리별 마지막 번호 가져오기
  Future<int> _getLastNumberForCategory(String category) async {
    debugPrint(
        '[getLastNumberForCategory] Fetching last number for category: $category');
    final questions = await fetchQuestions(category, 0, 1);
    if (questions.isEmpty) {
      return 0;
    }
    return questions
        .map((q) => int.tryParse(q.questionId.substring(1)) ?? 0)
        .reduce((a, b) => a > b ? a : b);
  }

  /// 새로운 질문 ID 생성
  Future<String> generateQuestionId(String category) async {
    final lastNumber = await _getLastNumberForCategory(category);
    return QuestionIdGenerator.generateNewId(
        category: category, lastNumber: lastNumber);
  }

  /// 질문 데이터 저장
  Future<void> writeQuestionData(QuestionData questionData) async {
    debugPrint('[writeQuestionData] Start writing question');
    if (questionData.questionId.isEmpty) {
      final newId = await generateQuestionId(questionData.category);
      questionData = questionData.copyWith(questionId: newId);
    }

    final path =
        '$basePath/${questionData.category.toLowerCase()}/${questionData.questionId}';
    await _dbService.writeDB(path, questionData.toJson());
    debugPrint('[writeQuestionData] Question saved at path: $path');
    debugPrint('[writeQuestionData] ${questionData.toJson()}');
  }

  /// 질문 데이터 업데이트
  Future<void> updateQuestionData(QuestionData updatedQuestion) async {
    final path =
        '$basePath/${updatedQuestion.category.toLowerCase()}/${updatedQuestion.questionId}';
    try {
      await _dbService.updateDB(path, updatedQuestion.toJson());
      debugPrint('[updateQuestionData] Question updated at path: $path');
    } catch (error) {
      debugPrint('[updateQuestionData] Error updating question: $error');
      rethrow;
    }
  }

  /// 특정 카테고리의 질문 가져오기 (페이징 기반)
  Future<List<QuestionData>> fetchQuestions(
      String category, int page, int pageSize) async {
    final path = '$basePath/${category.toLowerCase()}';
    final data = await _dbService.readDB(path);
    if (data == null) {
      return [];
    }

    final questions = data.entries
        .map((entry) =>
            QuestionData.fromJson(Map<String, dynamic>.from(entry.value)))
        .toList();

    questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final startIndex = page * pageSize;
    return startIndex < questions.length
        ? questions.sublist(
            startIndex, (startIndex + pageSize).clamp(0, questions.length))
        : [];
  }
}
