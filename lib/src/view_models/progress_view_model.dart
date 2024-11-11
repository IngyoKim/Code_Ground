import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/operations/progress_operation.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressOperation _progressOperation = ProgressOperation();
  ProgressData? _progressData;

  ProgressData? get progressData => _progressData;

  Future<void> fetchProgressData(String userId, String questionId) async {
    _progressData =
        await _progressOperation.readProgressData(userId, questionId);

    // 데이터가 없을 경우 초기 데이터를 쓰는 로직 추가
    if (_progressData == null) {
      final initialProgressData = ProgressData(
        userId: userId,
        experience: 0,
        level: 1,
        expToNextLevel: 100,
        questionId: questionId,
        timeTaken: 0,
        attempts: 0,
      );
      await _progressOperation.writeProgressData(initialProgressData);
      _progressData = initialProgressData;
    }

    notifyListeners();
  }

  Future<void> updateProgressData(
      String userId, String questionId, Map<String, dynamic> updates) async {
    await _progressOperation.updateProgressData(userId, questionId, updates);
    await fetchProgressData(userId, questionId);
  }
}
