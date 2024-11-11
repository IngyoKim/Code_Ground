import 'package:code_ground/src/services/database/datas/user_data.dart';
import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/database_service.dart';
import 'package:code_ground/src/models/user_data.dart';

class UserViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  UserData? _userData;

  UserData? get userData => _userData;

  Future<void> fetchUserData(String userId) async {
    final data = await _databaseService.readDB('users/$userId');
    if (data != null) {
      _userData = UserData(
        userId: userId,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        profileImageUrl: data['profileImageUrl'] ?? '',
      );
    }
    notifyListeners();
  }

  Future<void> updateUserData(
      String userId, Map<String, dynamic> updates) async {
    await _databaseService.updateDB('users/$userId', updates);
    await fetchUserData(userId);
  }

  Future<void> writeUserData(UserData newUser) async {
    final path = 'users/${newUser.userId}';
    await _databaseService.writeDB(path, {
      'name': newUser.name,
      'email': newUser.email,
      'profileImageUrl': newUser.profileImageUrl,
    });
    _userData = newUser;
    notifyListeners();
  }
}
