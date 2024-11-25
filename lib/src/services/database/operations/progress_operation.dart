import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';

const basePath = 'Progress';

class ProgressOperation {
  final DatabaseService _dbService = DatabaseService();

  // Write progress data
  Future<void> writeProgressData(ProgressData progressData) async {
    String path = '$basePath/${progressData.uid}';
    debugPrint(
        '[writeProgressData] Start writing progress data for path: $path');
    debugPrint('[writeProgressData] Data to write: ${progressData.toJson()}');
    try {
      await _dbService.writeDB(path, progressData.toJson());
      debugPrint('[writeProgressData] Successfully wrote data to $path');
    } catch (error) {
      debugPrint('[writeProgressData] Error writing data: $error');
      rethrow;
    }
  }

  // Read progress data
  Future<ProgressData?> readProgressData([String? uid]) async {
    debugPrint('[readProgressData] Start reading progress data');
    uid ??= FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      debugPrint('[readProgressData] No user is currently logged in');
      throw Exception('No user is currently logged in.');
    }

    String path = '$basePath/$uid';
    debugPrint('[readProgressData] Reading data for path: $path');
    try {
      final data = await _dbService.readDB(path);
      if (data != null) {
        debugPrint('[readProgressData] Data retrieved: $data');
        return ProgressData.fromJson(Map<String, dynamic>.from(data));
      } else {
        debugPrint('[readProgressData] No data found at path: $path');
        return null;
      }
    } catch (error) {
      debugPrint('[readProgressData] Error reading data: $error');
      rethrow;
    }
  }

  // Update progress data
  Future<void> updateProgressData(
      String userId, Map<String, dynamic> updates) async {
    String path = '$basePath/$userId';
    debugPrint(
        '[updateProgressData] Start updating progress data for path: $path');
    debugPrint('[updateProgressData] Updates: $updates');
    try {
      await _dbService.updateDB(path, updates);
      debugPrint('[updateProgressData] Successfully updated data at $path');
    } catch (error) {
      debugPrint('[updateProgressData] Error updating data: $error');
      rethrow;
    }
  }
}
