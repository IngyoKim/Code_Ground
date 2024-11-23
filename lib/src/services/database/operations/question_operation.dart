import 'package:flutter/foundation.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';

const basePath = 'Questions';

class QuestionOperation {
  final DatabaseService _dbService = DatabaseService();

  /// 특정 카테고리의 질문 가져오기 (페이징 기반)
  Future<List<QuestionData>> fetchQuestions(
      String category, int page, int pageSize) async {
    debugPrint('[fetchQuestions] Start fetching questions');
    debugPrint('Category: $category, Page: $page, PageSize: $pageSize');

    final path = '$basePath/${category.toLowerCase()}';
    final data = await _dbService.readDB(path);

    if (data == null) {
      debugPrint('[fetchQuestions] No data found at path: $path');
      return [];
    }

    final questions = data.entries
        .map((entry) =>
            QuestionData.fromJson(Map<String, dynamic>.from(entry.value)))
        .toList();

    questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final startIndex = page * pageSize;
    if (startIndex >= questions.length) {
      debugPrint(
          '[fetchQuestions] No more data to fetch. Total: ${questions.length}');
      return [];
    }

    final result = questions.sublist(
        startIndex, (startIndex + pageSize).clamp(0, questions.length));
    debugPrint(
        '[fetchQuestions] Fetched ${result.length} questions. StartIndex: $startIndex');
    return result;
  }

  /// 질문 데이터 저장
  Future<void> writeQuestionData(QuestionData questionData) async {
    debugPrint('[writeQuestionData] Start writing question');
    debugPrint('QuestionData: ${questionData.toJson()}');

    if (questionData.questionId.isEmpty) {
      debugPrint('[writeQuestionData] Generating new question ID');
      questionData = await _generateQuestionId(questionData);
    }

    final now = DateTime.now();
    questionData = questionData.copyWith(
      createdAt: questionData.createdAt.isAtSameMomentAs(DateTime(0))
          ? now
          : questionData.createdAt,
      updatedAt: now,
    );

    final path =
        '$basePath/${questionData.category.toLowerCase()}/${questionData.questionId}';
    await _dbService.writeDB(path, questionData.toJson());
    debugPrint('[writeQuestionData] Question saved at path: $path');
  }

  /// 질문 ID 생성
  Future<QuestionData> _generateQuestionId(QuestionData questionData) async {
    debugPrint('[generateQuestionId] Generating ID for question');
    final prefix = getPrefixFromCategory(questionData.category);
    debugPrint('[generateQuestionId] Prefix: $prefix');

    final lastNumber = await _getLastNumberForCategory(questionData.category);
    debugPrint('[generateQuestionId] Last number: $lastNumber');

    final newNumber = (lastNumber + 1).toString().padLeft(5, '0'); // 5자리로 패딩
    final newId = '$prefix$newNumber';

    debugPrint('[generateQuestionId] Generated ID: $newId');
    return questionData.copyWith(questionId: newId);
  }

  /// 카테고리 접두사 가져오기
  String getPrefixFromCategory(String category) {
    debugPrint(
        '[getPrefixFromCategory] Resolving prefix for category: $category');
    const categoryPrefixes = {
      'syntax': '1',
      'debugging': '2',
      'output': '3',
      'blank': '4',
      'sequencing': '5',
    };
    final prefix = categoryPrefixes[category.toLowerCase()] ?? '0';
    debugPrint('[getPrefixFromCategory] Prefix resolved: $prefix');
    return prefix;
  }

  /// 카테고리별 마지막 번호 가져오기
  Future<int> _getLastNumberForCategory(String category) async {
    debugPrint(
        '[getLastNumberForCategory] Fetching last number for category: $category');
    final questions = await fetchQuestions(category, 0, 1);
    if (questions.isEmpty) {
      debugPrint('[getLastNumberForCategory] No questions found.');
      return 0;
    }

    final lastNumber = questions
        .map((q) => int.tryParse(q.questionId.substring(1)) ?? 0)
        .reduce((a, b) => a > b ? a : b);
    debugPrint('[getLastNumberForCategory] Last number found: $lastNumber');
    return lastNumber;
  }
}
