import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:code_ground/src/models/user_data.dart';
import 'package:code_ground/src/services/database/database_service.dart';

const basePath = 'Users';

class UserManager {
  final DatabaseService _dbService = DatabaseService();

  // Write user data
  Future<void> writeUserData(UserData userData) async {
    String path = '$basePath/${userData.uid}';
    debugPrint('[writeUserData] Writing user data to path: $path');
    try {
      await _dbService.writeDB(path, userData.toJson());
      debugPrint('[writeUserData] Successfully wrote user data to $path');
      debugPrint('[writeUserData] ${userData.toJson()}');
    } catch (error) {
      debugPrint('[writeUserData] Error writing user data: $error');
      rethrow;
    }
  }

  // Read user data
  Future<UserData?> readUserData([String? uid]) async {
    debugPrint('[readUserData] Reading user data');
    uid ??= FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      debugPrint('[readUserData] No user is currently logged in.');
      throw Exception('No user is currently logged in.');
    }

    String path = '$basePath/$uid';
    try {
      final data = await _dbService.readDB(path);
      if (data != null) {
        return UserData.fromJson(Map<String, dynamic>.from(data));
      } else {
        debugPrint('[readUserData] No data found at path: $path');
        return null;
      }
    } catch (error) {
      debugPrint('[readUserData] Error reading user data: $error');
      rethrow;
    }
  }

  /// Update user data
  Future<void> updateUserData(Map<String, dynamic> updates,
      {String? uid}) async {
    uid ??= FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      debugPrint(
          '[updateUserData] No user is currently logged in or UID is missing.');
      throw Exception('No user is currently logged in or UID is missing.');
    }

    String path = '$basePath/$uid';
    debugPrint('[updateUserData] Updating user data at path: $path');
    try {
      await _dbService.updateDB(path, updates);
      debugPrint('[updateUserData] Successfully updated user data at $path');
    } catch (error) {
      debugPrint('[updateUserData] Error updating user data at $path: $error');
      rethrow;
    }
  }

  /// Fetch all users from the database
  Future<List<UserData>> fetchUsers([int? limit]) async {
    debugPrint('[fetchUsers] Fetching all users from database');
    try {
      // Fetch all users or apply limit if specified
      Query? query;
      if (limit != null) {
        query = FirebaseDatabase.instance.ref(basePath).limitToFirst(limit);
      }
      final userList = await _dbService.fetchDB(
        path: basePath,
        query: query,
      );

      // Convert raw data to UserData objects
      final users =
          userList.map((userMap) => UserData.fromJson(userMap)).toList();

      debugPrint('[fetchUsers] Successfully fetched ${users.length} users');
      return users;
    } catch (error) {
      debugPrint('[fetchUsers] Error fetching users: $error');
      rethrow;
    }
  }
}
