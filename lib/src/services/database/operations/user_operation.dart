import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';

const basePath = 'Users';

class UserOperation {
  final DatabaseService _dbService = DatabaseService();

  // Write user data
  Future<void> writeUserData(UserData userData) async {
    String path = '$basePath/${userData.userId}';
    debugPrint('[writeUserData] Writing user data to path: $path');
    debugPrint('[writeUserData] Data to write: ${userData.toJson()}');
    try {
      await _dbService.writeDB(path, userData.toJson());
      debugPrint('[writeUserData] Successfully wrote user data to $path');
    } catch (error) {
      debugPrint('[writeUserData] Error writing user data: $error');
      rethrow;
    }
  }

  // Initialize user data if it doesn't exist
  Future<void> initializeUserData() async {
    debugPrint('[initializeUserData] Initializing user data if not exists');
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint('[initializeUserData] No user is currently logged in.');
      return;
    }

    String path = '$basePath/${user.uid}';
    debugPrint('[initializeUserData] Checking user data at path: $path');
    try {
      final data = await _dbService.readDB(path);

      if (data == null) {
        debugPrint(
            '[initializeUserData] User data not found. Initializing default data.');
        final defaultUserData = UserData(
          userId: user.uid,
          name: user.displayName ?? 'Guest',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
          nickname: '', // Default empty or user-defined logic
          isAdmin: false, // Default value
        );

        await writeUserData(defaultUserData);
        debugPrint(
            '[initializeUserData] Default user data written for userId: ${user.uid}');
      } else {
        debugPrint(
            '[initializeUserData] User data already exists for userId: ${user.uid}');
      }
    } catch (error) {
      debugPrint('[initializeUserData] Error initializing user data: $error');
      rethrow;
    }
  }

  // Read user data
  Future<UserData?> readUserData([String? userId]) async {
    debugPrint('[readUserData] Reading user data');
    userId ??= FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      debugPrint('[readUserData] No user is currently logged in.');
      throw Exception('No user is currently logged in.');
    }

    String path = '$basePath/$userId';
    debugPrint('[readUserData] Reading data for path: $path');
    try {
      final data = await _dbService.readDB(path);
      if (data != null) {
        debugPrint('[readUserData] Data retrieved: $data');
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

  // Update user data
  Future<void> updateUserData(
      String userId, Map<String, dynamic> updates) async {
    String path = '$basePath/$userId';
    debugPrint('[updateUserData] Updating user data for path: $path');
    debugPrint('[updateUserData] Updates: $updates');
    try {
      await _dbService.updateDB(path, updates);
      debugPrint('[updateUserData] Successfully updated user data at $path');
    } catch (error) {
      debugPrint('[updateUserData] Error updating user data: $error');
      rethrow;
    }
  }

  // Fetch all user data (optional)
  Future<List<UserData>> fetchAllUsers() async {
    debugPrint('[fetchAllUsers] Fetching all users');
    try {
      final data = await _dbService.readDB(basePath);
      if (data != null) {
        final users = data.entries.map((entry) {
          return UserData.fromJson(Map<String, dynamic>.from(entry.value));
        }).toList();
        debugPrint('[fetchAllUsers] Retrieved ${users.length} users');
        return users;
      } else {
        debugPrint('[fetchAllUsers] No users found in database');
        return [];
      }
    } catch (error) {
      debugPrint('[fetchAllUsers] Error fetching all users: $error');
      rethrow;
    }
  }
}
