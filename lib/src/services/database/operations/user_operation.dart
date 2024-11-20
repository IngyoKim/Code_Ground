import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';

class UserOperation {
  final DatabaseService _databaseService = DatabaseService();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> writeUserData() async {
    if (user == null) {
      debugPrint("User not logged in.");
      return;
    }
    String path = 'users/${user!.uid}';
    debugPrint("Writing user data to $path");
    await _databaseService.writeDB(
      path,
      {
        'name': user?.displayName ?? '',
        'email': user?.email ?? '',
        'profileImageUrl': user?.photoURL ?? '',
        'nickname': '', // Default empty or assign a default value
        'isAdmin': false, // Default value, modify if needed
      },
    );
  }

  Future<UserData?> readUserData({String? uid}) async {
    final userId = uid ?? user?.uid;

    if (userId == null) {
      debugPrint("User not logged in and no UID provided.");
      return null;
    }

    String path = 'users/$userId';
    debugPrint("Reading user data from $path");

    final data = await _databaseService.readDB(path);

    if (data != null) {
      debugPrint("User data retrieved: $data");
      return UserData(
        userId: userId,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        profileImageUrl: data['profileImageUrl'] ?? '',
        nickname: data['nickname'] ?? '',
        isAdmin: data['isAdmin'] ?? false,
      );
    }

    debugPrint("No data found for user with UID $userId.");
    return null;
  }

  Future<void> updateUserData(Map<String, dynamic> updates) async {
    if (user == null) {
      debugPrint("User not logged in.");
      return;
    }
    String path = 'users/${user!.uid}';
    debugPrint("Updating user data at $path with $updates");
    await _databaseService.updateDB(path, updates);
  }
}
