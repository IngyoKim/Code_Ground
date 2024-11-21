import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth 사용
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';

const basePath = 'Progress';

class ProgressOperation {
  final DatabaseService _dbService = DatabaseService();

  // Write progress data
  Future<void> writeProgressData(ProgressData progressData) async {
    String path = '$basePath/${progressData.userId}';
    await _dbService.writeDB(path, progressData.toJson());
  }

  // Read progress data
  Future<ProgressData?> readProgressData([String? userId]) async {
    // userId가 비어있으면 현재 로그인된 유저의 UID를 가져옴
    userId ??= FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // 로그인된 유저가 없으면 null 반환
      throw Exception('No user is currently logged in.');
    }

    String path = '$basePath/$userId';
    final data = await _dbService.readDB(path);
    if (data != null) {
      return ProgressData.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // Update progress data
  Future<void> updateProgressData(
      String userId, Map<String, dynamic> updates) async {
    String path = '$basePath/$userId';
    await _dbService.updateDB(path, updates);
  }
}
