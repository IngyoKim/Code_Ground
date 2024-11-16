import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/progress_operation.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressOperation _progressOperation = ProgressOperation();
  ProgressData? _progressData;

  ProgressData? get progressData => _progressData;

  /// 진행 상황 불러오기
  Future<void> fetchProgressData([String? userId]) async {
    if (_progressData != null) return;
    _progressData = await _progressOperation.readProgressData(userId) ??
        ProgressData(
          userId: userId ?? '',
          level: 0,
          exp: 0,
          tier: 'Bronze',
          grade: 'V',
          score: 0,
          quizState: {},
        );

    // 초기 데이터 저장
    if (userId == null) {
      await _progressOperation.writeProgressData(_progressData!);
    }
    notifyListeners();
  }

  /// 경험치 추가 및 레벨 업 처리
  Future<void> addExp(int data) async {
    if (_progressData == null) await fetchProgressData();
    _progressData!.exp += data;

    // 경험치 처리 및 레벨 업
    while (_progressData!.exp >= 100) {
      _progressData!.exp -= 100;
      _progressData!.level++;
    }

    await _progressOperation.updateProgressData(_progressData!.userId, {
      'exp': _progressData!.exp,
      'level': _progressData!.level,
    });
    notifyListeners();
  }

  /// 점수 추가 및 티어 업데이트
  Future<void> addScore(int score) async {
    if (_progressData == null) await fetchProgressData();
    _progressData!.score += score;

    final newTier = _determineTierAndGrade(_progressData!.score);
    _progressData!
      ..tier = newTier['tier']!
      ..grade = newTier['grade']!;

    await _progressOperation.updateProgressData(_progressData!.userId, {
      'score': _progressData!.score,
      'tier': _progressData!.tier,
      'grade': _progressData!.grade,
    });
    notifyListeners();
  }

  /// 점수 기반 티어 결정
  Map<String, String> _determineTierAndGrade(int score) {
    for (final tier in tiers.reversed) {
      for (final grade in tier.grades.reversed) {
        if (score >= grade.minScore) {
          return {'tier': tier.name, 'grade': grade.name};
        }
      }
    }
    return {'tier': 'Bronze', 'grade': 'V'};
  }
}
