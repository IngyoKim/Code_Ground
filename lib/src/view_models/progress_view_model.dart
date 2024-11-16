import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/progress_operation.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressOperation _progressOperation = ProgressOperation();
  ProgressData? _progressData;

  ProgressData? get progressData => _progressData;

  // 진행 상황을 불러오는 메서드
  Future<void> fetchProgressData([String? userId]) async {
    _progressData = await _progressOperation.readProgressData(userId);

    if (_progressData == null) {
      _progressData = ProgressData(
        userId: '',
        level: 0,
        exp: 0,
        tier: 'Bronze',
        grade: 'V',
        score: 0,
        quizState: {},
      );
      await _progressOperation.writeProgressData(_progressData!);
    }

    notifyListeners();
  }

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

      await _progressOperation.updateProgressData(_progressData!.userId, {
        'level': _progressData!.level,
        'exp': _progressData!.exp,
        'tier': _progressData!.tier,
      });
    }
    // 상태 업데이트
    notifyListeners();
  }

  // 점수 추가 및 티어 업데이트
  Future<void> addScore(int score) async {
    if (_progressData == null) await fetchProgressData();

    _progressData!.score += score;
    final newTierAndGrade = _determineTierAndGrade(_progressData!.score);
    _progressData!.tier = newTierAndGrade['tier']!;
    _progressData!.grade = newTierAndGrade['grade']!;

    await _progressOperation.updateProgressData(_progressData!.userId, {
      'score': _progressData!.score,
      'tier': _progressData!.tier,
      'grade': _progressData!.grade,
    });

    notifyListeners();
  }

  // 점수에 따른 티어와 등급 결정
  Map<String, String> _determineTierAndGrade(int score) {
    for (final tier in tiers.reversed) {
      for (final grade in tier.grades.reversed) {
        if (score >= grade.minScore) {
          return {'tier': tier.name, 'grade': grade.name};
        }
      }
    }
    return {'tier': 'Bronze', 'grade': 'V'}; // 기본값
  }
}
