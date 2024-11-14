import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/database_service.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:flutter/material.dart';

class ProgressOperation {
  final DatabaseService _databaseService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ProgressData를 데이터베이스에 작성하는 함수
  Future<void> writeProgressData(ProgressData progressData) async {
    String path = 'progress/${progressData.userId}';
    await _databaseService.writeDB(path, {
      'level': progressData.level,
      'exp': progressData.exp,
      'tier': progressData.tier,
      'score': progressData.score,
      'quizState': progressData.quizState,
    });
  }

  // ProgressData를 데이터베이스에서 읽어오는 함수 (현재 사용자 ID 사용)
  Future<ProgressData?> readProgressData([String? userId]) async {
    // 현재 로그인한 사용자 ID를 기본값으로 설정
    final String currentUserId = userId ?? _auth.currentUser?.uid ?? '';

    if (currentUserId.isEmpty) {
      // 유저가 로그인하지 않은 경우
      debugPrint("No user logged in.");
      return null;
    }

    String path = 'progress/$currentUserId';
    final data = await _databaseService.readDB(path);
    if (data != null) {
      return ProgressData(
        userId: currentUserId,
        level: data['level'] ?? 0,
        exp: data['exp'] ?? 0,
        tier: data['tier'] ?? 'Bronze', // 기본값 설정
        score: data['score'] ?? 0,
        quizState: Map<String, bool>.from(data['quizState'] ?? {}),
      );
    }
    return null;
  }

  // ProgressData를 업데이트하는 함수
  Future<void> updateProgressData(
      String userId, Map<String, dynamic> updates) async {
    String path = 'progress/$userId';
    await _databaseService.updateDB(path, updates);
  }
}
