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
        experience: 0,
        solvedQuestions: [],
        questionStatus: {},
      );
      await _progressOperation.writeProgressData(_progressData!);
    }

    notifyListeners();
  }

  // 진행 상황을 업데이트하는 메서드
  Future<void> updateProgressData(ProgressData progressData) async {
    await _progressOperation.updateProgressData(progressData);
    _progressData = progressData; // 업데이트된 진행 상황 반영
    notifyListeners();
  }
}
