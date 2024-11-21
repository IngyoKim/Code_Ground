import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/progress_operation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth 사용

class ProgressViewModel with ChangeNotifier {
  final ProgressOperation _progressOperation = ProgressOperation();
  ProgressData? _progressData;

  ProgressData? get progressData => _progressData;

  /// Fetch progress data for a specific user or the current user if userId is null
  Future<void> fetchProgressData([String? userId]) async {
    try {
      final currentUserId = userId ?? FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('User ID is null and no user is logged in.');
      }

      _progressData = await _progressOperation.readProgressData(currentUserId);

      if (_progressData == null) {
        _progressData = ProgressData(
          userId: currentUserId,
          level: 1,
          exp: 0,
          score: 0,
          tier: 'Bronze',
          grade: 'V',
          questionState: {},
        );
        await _progressOperation.writeProgressData(_progressData!);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching progress data: $e');
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

      await _progressOperation.updateProgressData(currentUserId, updates);

      // Fetch the updated data
      _progressData = await _progressOperation.readProgressData(currentUserId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating progress data: $e');
    }
  }
}
