import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:code_ground/src/models/progress_data.dart';
import 'package:code_ground/src/models/tier_data.dart';
import 'package:code_ground/src/services/database/progress_manager.dart';

class ProgressViewModel with ChangeNotifier {
  final ProgressManager _progressManager = ProgressManager();

  ProgressData? _progressData;
  List<ProgressData> _rankings = [];
  bool _isFetchingRankings = false;
  bool _hasMoreData = true;
  // ignore: unused_field
  int? _lastFetchedValue;

  ProgressData? get progressData => _progressData;
  List<ProgressData> get rankings => _rankings;
  bool get isFetchingRankings => _isFetchingRankings;
  bool get hasMoreData => _hasMoreData;

  get allQuestions => null;

  get questionState => null;

  /// Fetch progress data for a specific user or the current user if userId is null
  Future<void> fetchProgressData([String? userId]) async {
    try {
      final currentUserId = userId ?? FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('User ID is null and no user is logged in.');
      }

      _progressData = await _progressManager.readProgressData(currentUserId);

      if (_progressData == null) {
        _progressData = ProgressData(
          uid: currentUserId,
          level: 1,
          exp: 0,
          score: 0,
          tier: 'Bronze',
          grade: 'V',
          questionState: {},
        );
        await _progressManager.writeProgressData(_progressData!);
      }

      _updateTier();

      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching progress data: $error');
      _progressData = null;
      notifyListeners();
    }
  }

  /// Update progress data for a specific user or the current user if userId is null
  Future<void> updateProgressData(Map<String, dynamic> updates,
      [String? userId]) async {
    try {
      final currentUserId = userId ?? FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('User ID is null and no user is logged in.');
      }

      await _progressManager.updateProgressData(currentUserId, updates);

      // Fetch the updated data
      _progressData = await _progressManager.readProgressData(currentUserId);

      _updateTier();

      notifyListeners();
    } catch (error) {
      debugPrint('Error updating progress data: $error');
    }
  }

  /// Tier 및 Grade 업데이트
  void _updateTier() {
    if (_progressData == null) return;

    final currentScore = _progressData!.score;
    String? newTier;
    String? newGrade;

    for (final tier in tiers.reversed) {
      for (final grade in tier.grades.reversed) {
        if (currentScore >= grade.minScore) {
          newTier = tier.name;
          newGrade = grade.name;
          break;
        }
      }
      if (newTier != null && newGrade != null) {
        break;
      }
    }

    // 현재 티어와 등급이 변경될 필요가 있을 때만 업데이트
    if (newTier != null && newGrade != null) {
      if (_progressData!.tier != newTier || _progressData!.grade != newGrade) {
        debugPrint('Updated tier to $newTier and grade to $newGrade');
        updateProgressData({
          'tier': newTier,
          'grade': newGrade,
        });
      }
    }
  }

  /// Fetch rankings by score or exp with pagination
  Future<void> fetchRankings({
    required String orderBy,
    int? lastValue,
    int limit = 10,
  }) async {
    if (_isFetchingRankings || !_hasMoreData) return;

    _isFetchingRankings = true;
    notifyListeners();

    try {
      final fetchedRankings = await _progressManager.fetchRankings(
        orderBy: orderBy,
        lastValue: lastValue,
        limit: limit,
      );

      if (fetchedRankings.isEmpty) {
        _hasMoreData = false;
      } else {
        // 마지막으로 가져온 `score` 값 업데이트
        _lastFetchedValue = fetchedRankings.last.score;

        _rankings.addAll(fetchedRankings);
      }

      debugPrint("Successfully fetched ${fetchedRankings.length} rankings");
    } catch (error) {
      debugPrint('Error fetching rankings: $error');
    } finally {
      _isFetchingRankings = false;
      notifyListeners();
    }
  }

  /// Reset the rankings and pagination state
  void resetRankings() {
    _rankings.clear();
    _hasMoreData = true;
    _lastFetchedValue = null;
    notifyListeners();
  }
}
