import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth 사용
import 'package:code_ground/src/services/database/datas/user_data.dart';

const basePath = 'Users';

class UserOperation {
  final DatabaseService _dbService = DatabaseService();

  // Write user data
  Future<void> writeUserData(UserData userData) async {
    String path = '$basePath/${userData.userId}';
    await _dbService.writeDB(path, userData.toJson());
  }

  // Initialize user data if it doesn't exist
  Future<void> initializeUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint("No user is currently logged in.");
      return;
    }

    String path = '$basePath/${user.uid}';
    final data = await _dbService.readDB(path);

    // If user data doesn't exist, write default data
    if (data == null) {
      debugPrint("User data not found. Initializing default data.");
      final defaultUserData = UserData(
        userId: user.uid,
        name: user.displayName ?? 'Guest',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        nickname: '', // Default empty or user-defined logic
        isAdmin: false, // Default value
      );

      await writeUserData(defaultUserData);
    } else {
      debugPrint("User data already exists for userId: ${user.uid}");
    }
  }

  // Read user data
  Future<UserData?> readUserData([String? userId]) async {
    // Use current logged-in user's UID if userId is null
    userId ??= FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // No user is logged in
      throw Exception('No user is currently logged in.');
    }

    String path = '$basePath/$userId';
    final data = await _dbService.readDB(path);
    if (data != null) {
      return UserData.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // Update user data
  Future<void> updateUserData(
      String userId, Map<String, dynamic> updates) async {
    String path = '$basePath/$userId';
    await _dbService.updateDB(path, updates);
  }

  // Fetch all user data (optional)
  Future<List<UserData>> fetchAllUsers() async {
    final data = await _dbService.readDB(basePath);
    if (data != null) {
      return data.entries.map((entry) {
        return UserData.fromJson(Map<String, dynamic>.from(entry.value));
      }).toList();
    }
    return [];
  }
}
