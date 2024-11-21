import 'package:code_ground/src/services/database/datas/question_data.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';

const basePath = 'Questions';

class QuestionOperation {
  final DatabaseService _dbService = DatabaseService();

  /// 카테고리 접두사 가져오기
  String getPrefixFromCategory(String category) {
    const categoryPrefixes = {
      'syntax': '1',
      'debugging': '2',
      'output': '3',
      'blank': '4',
      'sequencing': '5',
    };
    return categoryPrefixes[category.toLowerCase()] ?? '0';
  }

  /// 질문 데이터 저장
  Future<void> writeQuestionData(QuestionData questionData) async {
    if (questionData.questionId.isEmpty) {
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
  }

  /// 질문 ID 생성
  Future<QuestionData> _generateQuestionId(QuestionData questionData) async {
    final prefix = getPrefixFromCategory(questionData.category);
    final lastNumber = await _getLastNumberForCategory(questionData.category);

    final newNumber = (lastNumber + 1).toString().padLeft(5, '0'); // 5자리로 패딩
    final newId = '$prefix$newNumber';

    return questionData.copyWith(questionId: newId);
  }

  /// 카테고리별 마지막 번호 가져오기
  Future<int> _getLastNumberForCategory(String category) async {
    final questions = await fetchQuestionsByCategory(category);
    if (questions.isEmpty) return 0;

    final lastNumber = questions
        .map((q) => int.tryParse(q.questionId.substring(1)) ?? 0)
        .reduce((a, b) => a > b ? a : b);

    return lastNumber;
  }

  /// 특정 카테고리의 질문 가져오기
  Future<List<QuestionData>> fetchQuestionsByCategory(String category) async {
    final path = '$basePath/${category.toLowerCase()}';
    final data = await _dbService.readDB(path);

    if (data == null) return [];
    return data.entries
        .map((entry) =>
            QuestionData.fromJson(Map<String, dynamic>.from(entry.value)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// 모든 질문 가져오기
  Future<List<QuestionData>> fetchAllQuestions() async {
    final categories = ['syntax', 'debugging', 'output', 'blank', 'sequencing'];
    final allQuestions = <QuestionData>[];

    for (final category in categories) {
      final categoryQuestions = await fetchQuestionsByCategory(category);
      allQuestions.addAll(categoryQuestions);
    }

    allQuestions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allQuestions;
  }

  /// 특정 질문 읽기
  Future<QuestionData?> readQuestionData(
      String category, String questionId) async {
    final path = '$basePath/${category.toLowerCase()}/$questionId';
    final data = await _dbService.readDB(path);
    return data != null
        ? QuestionData.fromJson(Map<String, dynamic>.from(data))
        : null;
  }

  /// 질문 데이터 업데이트
  Future<void> updateQuestionData(
      String category, String questionId, Map<String, dynamic> updates) async {
    updates['updatedAt'] = DateTime.now().toIso8601String();

    final path = '$basePath/${category.toLowerCase()}/$questionId';
    await _dbService.updateDB(path, updates);
  }
}
