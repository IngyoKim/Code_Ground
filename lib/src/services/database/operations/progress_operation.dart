import 'package:code_ground/src/services/database/database_service.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';

class ProgressOperations {
  final DatabaseService _databaseService = DatabaseService();

  Future<void> writeProgressData(ProgressData progressData) async {
    String path = 'progress/${progressData.userId}/${progressData.questionId}';
    await _databaseService.writeDB(path, {
      'experience': progressData.experience,
      'level': progressData.level,
      'expToNextLevel': progressData.expToNextLevel,
      'lastUpdated': progressData.lastUpdated.toIso8601String(),
      'questionId': progressData.questionId,
      'solvedAt': progressData.solvedAt.toIso8601String(),
      'timeTaken': progressData.timeTaken,
      'attempts': progressData.attempts,
    });
  }

  Future<ProgressData?> readProgressData(
      String userId, String questionId) async {
    String path = 'progress/$userId/$questionId';
    final data = await _databaseService.readDB(path);
    if (data != null) {
      return ProgressData(
        userId: userId,
        experience: data['experience'] ?? 0,
        level: data['level'] ?? 1,
        expToNextLevel: data['expToNextLevel'] ?? 100,
        lastUpdated: DateTime.parse(data['lastUpdated']),
        questionId: questionId,
        solvedAt: DateTime.parse(data['solvedAt']),
        timeTaken: data['timeTaken'] ?? 0,
        attempts: data['attempts'] ?? 1,
      );
    }
    return null;
  }

  Future<void> updateProgressData(
      String userId, String questionId, Map<String, dynamic> updates) async {
    String path = 'progress/$userId/$questionId';
    await _databaseService.updateDB(path, updates);
  }
}
