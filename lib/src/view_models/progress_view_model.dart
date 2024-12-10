import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:code_ground/src/models/progress_data.dart';
import 'package:code_ground/src/services/database/progress_manager.dart';

class ProgressViewModel with ChangeNotifier {
  final ProgressManager _progressManager = ProgressManager();

  ProgressData? _progressData;
  List<ProgressData> _rankings = [];
  bool _isFetchingRankings = false;

  ProgressData? get progressData => _progressData;
  List<ProgressData> get rankings => _rankings;
  bool get isFetchingRankings => _isFetchingRankings;

  get allQuestions => null;

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
      notifyListeners();
    } catch (error) {
      debugPrint('Error updating progress data: $error');
    }
  }

  /// Fetch rankings by score or exp with pagination
  Future<void> fetchRankings({
    required String orderBy, // 'score' or 'exp'
    int? lastValue,
    int limit = 10,
  }) async {
    if (_isFetchingRankings) return; // 중복 요청 방지

    _isFetchingRankings = true;
    Future.microtask(() => notifyListeners());

    try {
      final fetchedRankings = await _progressManager.fetchRankings(
        orderBy: orderBy,
        lastValue: lastValue,
        limit: limit,
      );

      if (lastValue == null) {
        _rankings = fetchedRankings;
      } else {
        _rankings.addAll(fetchedRankings);
      }
      debugPrint("Working fetchRanking");

      Future.microtask(() => notifyListeners());
    } catch (error) {
      debugPrint('Error fetching rankings: $error');
    } finally {
      _isFetchingRankings = false;
      notifyListeners();
    }
  }

  void updateSignal(String s) {}
}
