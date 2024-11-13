import 'package:code_ground/src/services/database/database_service.dart';
import 'package:code_ground/src/services/database/datas/question_data.dart';

class QuestionOperation {
  final DatabaseService _databaseService = DatabaseService();

  Future<void> writeQuestionData(QuestionData questionData) async {
    String path = 'questions/${questionData.questionId}';
    await _databaseService.writeDB(path, {
      'title': questionData.title,
      'category': questionData.category,
      'description': questionData.description,
      'difficulty': questionData.difficulty,
      'tags': questionData.tags,
      'createdAt': questionData.createdAt.toIso8601String(),
      'updatedAt': questionData.updatedAt.toIso8601String(),
    });
  }

  Future<QuestionData?> readQuestionData(String questionId) async {
    String path = 'questions/$questionId';
    final data = await _databaseService.readDB(path);
    if (data != null) {
      return QuestionData(
        questionId: questionId,
        title: data['title'] ?? '',
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        difficulty: data['difficulty'] ?? 'Unknown',
        tags: List<String>.from(data['tags'] ?? []),
        createdAt: DateTime.parse(data['createdAt']),
        updatedAt: DateTime.parse(data['updatedAt']),
      );
    }
    return null;
  }

  Future<void> updateQuestionData(
      String questionId, Map<String, dynamic> updates) async {
    String path = 'questions/$questionId';
    await _databaseService.updateDB(path, updates);
  }
}
