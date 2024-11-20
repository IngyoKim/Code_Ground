import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/tier_data.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/progress_operation.dart';

class ProgressViewModel extends ChangeNotifier {
  final ProgressOperation _progressOperation = ProgressOperation();
  ProgressData? _progressData;

  ProgressData? get progressData => _progressData;

  /// Fetch progress data from the database.
  Future<void> fetchProgressData() async {
    _progressData = await _progressOperation.readProgressData();

    /// If no data exists, initialize with default values and save.
    if (_progressData == null) {
      _progressData = ProgressData(
        userId: '',

        /// Set the current user's ID.
        level: 1,

        /// Start with level 1.
        exp: 0,

        /// Initialize experience to 0.
        tier: 'Bronze',

        /// Set the initial tier to Bronze.
        grade: 'V',

        /// Set the initial grade to V.
        score: 0,

        /// Start score at 0.
        questionState: {},
      );
      await _progressOperation.writeProgressData(_progressData!);
    }

    notifyListeners();
  }

  /// Set progress data directly.
  void setProgressData(ProgressData progressData) {
    _progressData = progressData;
    notifyListeners();
  }

  /// Add experience points and handle level-ups.
  Future<void> addExp(int data) async {
    if (_progressData == null) await fetchProgressData();

    _progressData!.exp += data;

    /// Handle level-up logic.
    while (_progressData!.exp >= 100) {
      _progressData!.exp -= 100;
      _progressData!.level++;
    }

    /// Save updated data to the database.
    await _progressOperation.updateProgressData(_progressData!.userId, {
      'exp': _progressData!.exp,
      'level': _progressData!.level,
    });

    notifyListeners();
  }

  /// Add score and update tier/grade.
  Future<void> addScore(int score) async {
    if (_progressData == null) await fetchProgressData();

    _progressData!.score += score;

    /// Determine tier and grade based on the score.
    final newTier = _determineTierAndGrade(_progressData!.score);
    _progressData!
      ..tier = newTier['tier']!
      ..grade = newTier['grade']!;

    /// Save updated data to the database.
    await _progressOperation.updateProgressData(_progressData!.userId, {
      'score': _progressData!.score,
      'tier': _progressData!.tier,
      'grade': _progressData!.grade,
    });

    notifyListeners();
  }

  /// Determine tier and grade based on score.
  Map<String, String> _determineTierAndGrade(int score) {
    for (final tier in tiers.reversed) {
      for (final grade in tier.grades.reversed) {
        if (score >= grade.minScore) {
          return {'tier': tier.name, 'grade': grade.name};
        }
      }
    }

    /// Default values.
    return {'tier': 'Bronze', 'grade': 'V'};
  }

  /// Update the state of a question.
  Future<void> updateQuestionState(String questionId, bool state) async {
    if (_progressData == null) await fetchProgressData();
    _progressData!.questionState[questionId] = state;
    await _progressOperation.updateProgressData(_progressData!.userId, {
      'questionState': _progressData!.questionState,
    });
    notifyListeners();
  }
}
