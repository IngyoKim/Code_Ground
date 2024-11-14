import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/progress_operation.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressOperation _progressOperation = ProgressOperation();
  ProgressData? _progressData;

  ProgressData? get progressData => _progressData;

  // 진행 상황을 불러오는 메서드
  Future<void> fetchProgressData([String? userId]) async {
    _progressData = await _progressOperation.readProgressData(userId);

    // 데이터가 없을 경우 초기 데이터를 쓰는 로직 추가
    if (_progressData == null) {
      _progressData = ProgressData(
        userId: '', // userId는 빈 값으로 두고, 실제 데이터는 유저 로그인 시에 적용
        level: 0,
        exp: 0,
        tier: 'Bronze', // 초기 tier 설정
        score: 0,
        quizState: {},
      );
      await _progressOperation.writeProgressData(_progressData!);
    }

    notifyListeners();
  }

  // 경험치를 추가하는 메서드
  Future<void> addExp(int data) async {
    if (_progressData == null) await fetchProgressData();

    _progressData!.exp += data;
    await _progressOperation.updateProgressData(_progressData!.userId, {
      'exp': _progressData!.exp,
    });

    if (_progressData!.exp >= 100) await levelUp();

    // 업데이트된 데이터를 다시 불러와서 상태 반영
    await fetchProgressData();
  }

  // 레벨 업 메서드
  Future<void> levelUp() async {
    if (_progressData == null) await fetchProgressData();

    // 경험치가 100 이상이면 레벨을 올리고 경험치를 차감
    while (_progressData!.exp >= 100) {
      _progressData!.level += 1;
      _progressData!.exp -= 100;

      // 티어 업데이트 로직 추가 (예: 특정 레벨에 따라 티어를 변경)
      _progressData!.tier = _determineTier(_progressData!.level);

      await _progressOperation.updateProgressData(_progressData!.userId, {
        'level': _progressData!.level,
        'exp': _progressData!.exp,
        'tier': _progressData!.tier,
      });
    }
    // 상태 업데이트
    notifyListeners();
  }

  // 레벨에 따른 티어를 결정하는 메서드
  String _determineTier(int level) {
    if (level >= 10) {
      return 'Gold';
    } else if (level >= 5) {
      return 'Silver';
    } else {
      return 'Bronze';
    }
  }
}
