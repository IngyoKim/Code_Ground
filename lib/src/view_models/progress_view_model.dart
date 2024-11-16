import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/progress_operation.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressOperation _progressOperation = ProgressOperation();
  ProgressData? _progressData;

  ProgressData? get progressData => _progressData;

  /// 진행 상황 불러오기
  Future<void> fetchProgressData() async {
    _progressData = await _progressOperation.readProgressData();

    // 데이터가 없을 경우 초기 데이터를 쓰는 로직 추가
    if (_progressData == null) {
      _progressData = ProgressData(
        userId: '', // 현재 로그인된 사용자 ID를 설정
        level: 1, // 초기 레벨은 1로 시작
        exp: 0, // 경험치는 0으로 초기화
        tier: 'Bronze', // 초기 티어는 Bronze로 설정
        grade: 'V', // 초기 등급은 V로 설정
        score: 0, // 점수는 0으로 시작
        quizState: {
          'Syntax': false, // 각 카테고리의 문제 상태를 false로 초기화
          'Debugging': false,
          'Output': false,
          'Blank': false,
          'Sequencing': false,
        },
      );
      await _progressOperation.writeProgressData(_progressData!);
    }

    notifyListeners();
  }

  /// 경험치 추가 및 레벨 업 처리
  Future<void> addExp(int data) async {
    if (_progressData == null) await fetchProgressData();

    _progressData!.exp += data;

    // 레벨 업 처리
    while (_progressData!.exp >= 100) {
      _progressData!.exp -= 100;
      _progressData!.level++;
    }

    // 업데이트된 데이터 저장
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

    // 티어와 등급 결정
    final newTier = _determineTierAndGrade(_progressData!.score);
    _progressData!
      ..tier = newTier['tier']!
      ..grade = newTier['grade']!;

    // 업데이트된 데이터 저장
    await _progressOperation.updateProgressData(_progressData!.userId, {
      'score': _progressData!.score,
      'tier': _progressData!.tier,
      'grade': _progressData!.grade,
    });

    notifyListeners();
  }

  /// 점수 기반 티어와 등급 결정
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
