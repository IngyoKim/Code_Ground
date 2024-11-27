import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';

const basePath = 'Questions';

class QuestionOperation {
  final DatabaseService _dbService = DatabaseService();

  // 카테고리별 접두사
  static const Map<String, String> _categoryPrefixes = {
    'syntax': '1',
    'debugging': '2',
    'output': '3',
    'blank': '4',
    'sequencing': '5',
  };

  /// ID로 카테고리 추출
  String? _getCategoryFromId(String questionId) {
    final prefix = questionId.substring(0, 1);
    return _categoryPrefixes.entries
            .firstWhere((entry) => entry.value == prefix,
                orElse: () => const MapEntry('', ''))
            .key
            .isNotEmpty
        ? _categoryPrefixes.entries
            .firstWhere((entry) => entry.value == prefix)
            .key
        : null;
  }

  /// 카테고리 접두사 가져오기
  String _getPrefixFromCategory(String category) {
    return _categoryPrefixes[category.toLowerCase()] ?? '0';
  }

  /// 질문 ID로 질문 가져오기
  Future<QuestionData?> fetchQuestionById(String questionId) async {
    final category = _getCategoryFromId(questionId);
    if (category == null) {
      debugPrint('[fetchQuestionById] Invalid question ID: $questionId');
      return null;
    }

    final path = '$basePath/${category.toLowerCase()}/$questionId';
    try {
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

  /// 새로운 질문 ID 생성
  Future<String> generateQuestionId(String category) async {
    debugPrint('[generateQuestionId] Generating ID for category: $category');
    final prefix = _getPrefixFromCategory(category);

    // 가장 최신의 질문 데이터를 가져옴
    final questions = await fetchQuestions(category);
    final lastNumber = questions
        .map((q) => int.tryParse(q.questionId.substring(1)) ?? 0)
        .fold(0, (max, value) => value > max ? value : max);

    final newNumber = (lastNumber + 1).toString().padLeft(5, '0'); // 5자리 패딩
    return '$prefix$newNumber';
  }

  /// 질문 데이터 저장
  Future<void> writeQuestionData(QuestionData questionData) async {
    debugPrint('[writeQuestionData] Writing question data');
    if (questionData.questionId.isEmpty) {
      final newId = await generateQuestionId(questionData.category);
      questionData = questionData.copyWith(questionId: newId);
    }

    final path =
        '$basePath/${questionData.category.toLowerCase()}/${questionData.questionId}';
    try {
      await _dbService.writeDB(path, questionData.toJson());
      debugPrint(
          '[writeQuestionData] Successfully wrote question data at path: $path');
    } catch (error) {
      debugPrint('[writeQuestionData] Error writing question data: $error');
      rethrow;
    }
  }

  /// 질문 데이터 업데이트
  Future<void> updateQuestionData(QuestionData updatedQuestion) async {
    final path =
        '$basePath/${updatedQuestion.category.toLowerCase()}/${updatedQuestion.questionId}';
    try {
      await _dbService.updateDB(path, updatedQuestion.toJson());
      debugPrint(
          '[updateQuestionData] Successfully updated question at path: $path');
    } catch (error) {
      debugPrint('[updateQuestionData] Error updating question data: $error');
      rethrow;
    }
  }

  /// 특정 카테고리의 질문 가져오기
  Future<List<QuestionData>> fetchQuestions(
    String category, {
    String? lastQuestionId, // 마지막으로 로드한 질문 ID
    int limit = 10, // 로드할 데이터의 개수 (기본값: 10)
  }) async {
    final path = '$basePath/${category.toLowerCase()}';
    try {
      Query query = _dbService.database.ref(path).orderByKey();

      if (lastQuestionId != null) {
        query = query.endBefore(lastQuestionId); // 페이징 처리
      }

      query = query.limitToLast(limit); // 로드할 데이터 개수 제한

      final snapshot = await query.get();

      if (!snapshot.exists) {
        return [];
      }

      return snapshot.children
          .map((child) => QuestionData.fromJson(
              Map<String, dynamic>.from(child.value as Map)))
          .toList()
          .reversed
          .toList(); // 역순 정렬 (Firebase는 기본적으로 오름차순 정렬)
    } catch (error) {
      debugPrint('[fetchQuestions] Error: $error');
      return [];
    }
  }
}
