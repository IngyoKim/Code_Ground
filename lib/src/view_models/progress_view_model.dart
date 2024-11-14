import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/progress_operation.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressOperation _progressOperation = ProgressOperation();
  ProgressData? _progressData;

  ProgressData? get progressData => _progressData;

  // 진행 상황을 불러오는 메서드
  Future<void> fetchProgressData() async {
    _progressData = await _progressOperation.readProgressData();

    // 데이터가 없을 경우 초기 데이터를 쓰는 로직 추가
    if (_progressData == null) {
      _progressData = ProgressData(
        userId: '', // userId는 빈 값으로 두고, 실제 데이터는 유저 로그인 시에 적용
        level: 0,
        exp: 0,
        solvedQuestions: [],
        questionStatus: {},
      );
      await _progressOperation.writeProgressData(_progressData!);
    }

    notifyListeners();
  }

  // 진행 상황을 업데이트하는 메서드
  Future<void> addExp(int data) async {
    if (_progressData == null) {
      debugPrint("Progress data not loaded. Fetching progress data...");
      await fetchProgressData();
      if (_progressData == null) {
        debugPrint("Failed to load progress data.");
        return;
      }
    }

    // 기존 경험치에 experiencePoints를 더하여 데이터베이스에 반영
    _progressData!.exp += data;
    await _progressOperation.updateProgressData({'exp': _progressData!.exp});

    if (_progressData!.exp >= 100) {
      await increaseLevel();
    }

    // 업데이트된 데이터를 다시 불러와서 상태 반영
    await fetchProgressData();
  }

  Future<void> increaseLevel() async {
    if (_progressData == null) {
      debugPrint("Progress data not loaded. Fetching progress data...");
      await fetchProgressData();
      if (_progressData == null) {
        debugPrint("Failed to load progress data.");
        return;
      }
    }

    // 경험치가 100 이상이면 레벨을 올리고 경험치를 차감
    while (_progressData!.exp >= 100) {
      _progressData!.level += 1;
      _progressData!.exp -= 100;

      await _progressOperation.updateProgressData({
        'level': _progressData!.level,
        'exp': _progressData!.exp,
      });
    }
    // 상태 업데이트
    await fetchProgressData();
  }
}
