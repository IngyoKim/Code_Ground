import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/database_service.dart';

class ProgressOperation {
  final DatabaseService _databaseService = DatabaseService();
  final User? user = FirebaseAuth.instance.currentUser;

  // 유저의 진행 상황을 데이터베이스에 저장
  Future<void> writeProgressData(ProgressData progressData) async {
    if (user == null) {
      debugPrint("User not logged in.");
      return;
    }
    String path = 'progress/${user!.uid}';
    debugPrint("Writing progress data to $path");
    await _databaseService.writeDB(path, {
      'level': progressData.level,
      'experience': progressData.experience,
      'solvedQuestions': progressData.solvedQuestions,
      'questionStatus': progressData.questionStatus.map((key, value) =>
          MapEntry(key, value?.toIso8601String())), // DateTime을 String으로 변환
    });
  }

  // 유저의 진행 상황을 데이터베이스에서 읽기
  Future<ProgressData?> readProgressData() async {
    if (user == null) {
      debugPrint("User not logged in.");
      return null;
    }
    String path = 'progress/${user!.uid}';
    debugPrint("Reading progress data from $path");
    final data = await _databaseService.readDB(path);
    if (data != null) {
      debugPrint("Progress data retrieved: $data");
      return ProgressData(
        userId: user!.uid,
        level: data['level'] ?? 0,
        experience: data['experience'] ?? 0,
        solvedQuestions: List<String>.from(data['solvedQuestions'] ?? []),
        questionStatus: Map<String, DateTime?>.from(data['questionStatus']?.map(
                (key, value) => MapEntry(
                    key, value != null ? DateTime.parse(value) : null)) ??
            {}),
      );
    }
    debugPrint("No progress data found for user.");
    return null;
  }

  // 유저의 진행 상황을 업데이트
  Future<void> updateProgressData(ProgressData progressData) async {
    if (user == null) {
      debugPrint("User not logged in.");
      return;
    }
    String path = 'progress/${user!.uid}';
    debugPrint(
        "Updating progress data at $path with ${progressData.toString()}");
    await _databaseService.updateDB(path, {
      'level': progressData.level,
      'experience': progressData.experience,
      'solvedQuestions': progressData.solvedQuestions,
      'questionStatus': progressData.questionStatus.map((key, value) =>
          MapEntry(key, value?.toIso8601String())), // DateTime을 String으로 변환
    });
  }
}
