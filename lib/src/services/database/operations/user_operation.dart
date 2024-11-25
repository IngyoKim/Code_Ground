import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';

const basePath = 'Users';

class UserOperation {
  final DatabaseService _dbService = DatabaseService();

  // Write user data
  Future<void> writeUserData(UserData userData) async {
    String path = '$basePath/${userData.uid}';
    debugPrint('[writeUserData] Writing user data to path: $path');
    try {
      await _dbService.writeDB(path, userData.toJson());
      debugPrint('[writeUserData] Successfully wrote user data to $path');
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
}
