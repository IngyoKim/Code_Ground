import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:code_ground/src/models/progress_data.dart';
import 'package:code_ground/src/services/database/database_service.dart';

const basePath = 'Progress';

class ProgressManager {
  final DatabaseService _dbService = DatabaseService();

  // Write progress data
  Future<void> writeProgressData(ProgressData progressData) async {
    String path = '$basePath/${progressData.uid}';
    debugPrint(
        '[writeProgressData] Start writing progress data for path: $path');
    try {
      await _dbService.writeDB(path, progressData.toJson());
      debugPrint('[writeProgressData] Successfully wrote data to $path');
      debugPrint('[writeProgressData] ${progressData.toJson()}');
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
    try {
      await _dbService.updateDB(path, updates);
      debugPrint('[updateProgressData] Successfully updated data at $path');
    } catch (error) {
      debugPrint('[updateProgressData] Error updating data: $error');
      rethrow;
    }
  }

  // Fetch progress data
  Future<List<ProgressData>> fetchRankings({
    required String orderBy,
    int? lastValue,
    int limit = 10,
  }) async {
    const path = basePath;
    debugPrint('[fetchRankings] Fetching rankings by $orderBy');

    try {
      Query query = _dbService.database.ref(path).orderByChild(orderBy);

      if (lastValue != null) {
        query = query.endAt(lastValue);
      }

      query = query.limitToLast(limit + 1);

      final List<Map<String, dynamic>> rawData =
          await _dbService.fetchDB(path: path, query: query);

      final List<ProgressData> rankings =
          rawData.map((data) => ProgressData.fromJson(data)).toList();

      rankings
          .sort((a, b) => b.toJson()[orderBy].compareTo(a.toJson()[orderBy]));

      if (lastValue != null && rankings.isNotEmpty) {
        rankings.removeWhere((data) => data.toJson()[orderBy] == lastValue);
      }

      return rankings;
    } catch (error) {
      debugPrint('[fetchRankings] Error fetching rankings: $error');
      return [];
    }
  }
}
