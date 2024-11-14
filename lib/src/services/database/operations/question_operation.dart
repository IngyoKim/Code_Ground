import 'package:code_ground/src/services/database/database_service.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

class QuestionOperation {
  final DatabaseService _databaseService = DatabaseService();

  // questionId를 생성 시간 기반으로 생성하는 메서드
  String generateQuestionId() {
    return DateTime.now()
        .toIso8601String()
        .replaceAll('-', '')
        .replaceAll(':', '')
        .replaceAll('.', '');
  }

  // QuestionData를 데이터베이스에 저장하는 함수
  Future<void> writeQuestionData(QuestionData questionData) async {
    // questionId를 생성
    String questionId = generateQuestionId();

    String path = 'questions/${questionData.category}/$questionId';
    await _databaseService.writeDB(path, {
      'title': questionData.title,
      'writer': questionData.writer,
      'category': questionData.category,
      'description': questionData.description,
      'difficulty': questionData.difficulty,
      'rewardExp': questionData.rewardExp,
      'rewardScore': questionData.rewardScore,
      'questionType': questionData.questionType,
      'solvedCount': questionData.solvedCount,
      'updatedAt': questionData.updatedAt.toIso8601String(),
    });
  }

  // QuestionData를 데이터베이스에서 읽어오는 함수
  Future<QuestionData?> readQuestionData(
      String category, String questionId) async {
    String path = 'questions/$category/$questionId';
    final data = await _databaseService.readDB(path);
    if (data != null) {
      return QuestionData(
        questionId: questionId,
        writer: data['writer'] ?? '',
        category: data['category'] ?? category,
        questionType: data['questionType'] ?? 'Unknown',
        updatedAt: DateTime.parse(data['updatedAt']),
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        answer: data['answer'] ?? '',
        difficulty: data['difficulty'] ?? 'Unknown',
        rewardExp: data['rewardExp'] ?? 0,
        rewardScore: data['rewardScore'] ?? 0,
        solvedCount: data['solvedCount'] ?? 0,
      );
    }
    return null;
  }

  // QuestionData를 업데이트하는 함수
  Future<void> updateQuestionData(
      String category, String questionId, Map<String, dynamic> updates) async {
    String path = 'questions/$category/$questionId';
    await _databaseService.updateDB(path, updates);
  }
}
