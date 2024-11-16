import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:flutter/material.dart';

class ProgressOperation {
  final DatabaseService _databaseService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 현재 로그인된 사용자 ID 가져오기
  String getCurrentUserId() {
    final userId = _auth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      debugPrint("Error: No user is currently logged in.");
      throw Exception("User ID is empty");
    }
    return userId;
  }

  /// ProgressData를 데이터베이스에 작성하는 함수
  Future<void> writeProgressData(ProgressData progressData) async {
    try {
      final userId = getCurrentUserId();
      final path = 'progress/$userId';

      debugPrint("Writing ProgressData to $path: $progressData");
      await _databaseService.writeDB(path, {
        'level': progressData.level,
        'exp': progressData.exp,
        'tier': progressData.tier,
        'grade': progressData.grade,
        'score': progressData.score,
        'quizState': progressData.quizState,
      });
    } catch (e) {
      debugPrint("Failed to write ProgressData: $e");
    }
  }

  /// ProgressData를 데이터베이스에서 읽어오는 함수
  Future<ProgressData?> readProgressData([String? userId]) async {
    try {
      final currentUserId = userId ?? getCurrentUserId();
      final path = 'progress/$currentUserId';

      debugPrint("Reading ProgressData from $path");
      final data = await _databaseService.readDB(path);

      if (data != null) {
        debugPrint("Data retrieved: $data");
        return ProgressData(
          userId: currentUserId,
          level: data['level'] ?? 0,
          exp: data['exp'] ?? 0,
          tier: data['tier'] ?? 'Bronze',
          grade: data['grade'] ?? 'V',
          score: data['score'] ?? 0,
          quizState: Map<String, bool>.from(data['quizState'] ?? {}),
        );
      }

      debugPrint("No ProgressData found for userId: $currentUserId");
      return null;
    } catch (e) {
      debugPrint("Failed to read ProgressData: $e");
      return null;
    }
  }

  /// ProgressData를 업데이트하는 함수
  Future<void> updateProgressData(
      String userId, Map<String, dynamic> updates) async {
    try {
      final currentUserId = getCurrentUserId();
      if (currentUserId != userId) {
        debugPrint(
            "Warning: Updating data for a userId ($userId) different from the logged-in user ($currentUserId).");
      }
      final path = 'progress/$userId';

      debugPrint("Updating ProgressData at $path with $updates");
      await _databaseService.updateDB(path, updates);
    } catch (e) {
      debugPrint("Failed to update ProgressData: $e");
    }
  }
}
