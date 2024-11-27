import 'package:flutter/foundation.dart';
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
    final categoryEntry = _categoryPrefixes.entries.firstWhere(
        (entry) => entry.value == prefix,
        orElse: () => const MapEntry('', ''));
    return categoryEntry.key.isNotEmpty ? categoryEntry.key : null;
  }

  /// 카테고리 접두사 가져오기
  String _getPrefixFromCategory(String category) {
    return _categoryPrefixes[category.toLowerCase()] ?? '0';
  }

  /// 질문 ID로 질문 가져오기
  Future<QuestionData?> fetchQuestionById(String questionId) async {
    try {
      final category = _getCategoryFromId(questionId);
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
    final prefix = _getPrefixFromCategory(category);
    final newNumber = (lastNumber + 1).toString().padLeft(5, '0'); // 5자리 패딩
    return '$prefix$newNumber';
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

  /// 특정 카테고리의 질문 가져오기
  Future<List<QuestionData>> fetchQuestions(
      String category, int page, int pageSize) async {
    final path = '$basePath/${category.toLowerCase()}';

    try {
      final data = await _dbService.fetchDB(
        path,
        orderByChild: 'createdAt', // createdAt 필드 기준으로 정렬
        limitToLast: (page + 1) * pageSize, // 필요한 데이터만 가져오기
      );

      if (data.isEmpty) {
        return [];
      }

      // 최신순 정렬 및 페이징 처리
      return data
          .map((json) => QuestionData.fromJson(json))
          .toList()
          .reversed // Firebase에서 oldest-to-newest로 반환되므로 최신순으로 정렬
          .skip(page * pageSize) // 페이지 시작 위치
          .take(pageSize) // 페이지 크기만큼 데이터 가져오기
          .toList();
    } catch (error) {
      debugPrint('[fetchQuestions] Error fetching paged questions: $error');
      return [];
    }
  }
}
