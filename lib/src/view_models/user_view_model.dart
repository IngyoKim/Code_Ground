import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';
import 'package:code_ground/src/services/database/operations/user_operation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth 사용

class UserViewModel with ChangeNotifier {
  final UserOperation _userOperation = UserOperation();
  UserData? _userData;

  UserData? get userData => _userData;

  /// Fetch user data for a specific user or the current user if userId is null
  Future<void> fetchUserData([String? userId]) async {
    try {
      // 현재 로그인된 유저의 ID를 가져옴
      final currentUserId = userId ?? FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('User ID is null and no user is logged in.');
      }

      // 데이터베이스에서 유저 데이터 읽기
      _userData = await _userOperation.readUserData(currentUserId);

      // 유저 데이터가 없으면 초기화
      if (_userData == null) {
        final User? firebaseUser = FirebaseAuth.instance.currentUser;

        _userData = UserData(
          userId: currentUserId,
          name: firebaseUser?.displayName ?? 'Guest',
          email: firebaseUser?.email ?? '',
          photoUrl: firebaseUser?.photoURL ?? '',
          nickname: '',
          isAdmin: false,
        );

        await _userOperation.writeUserData(_userData!);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      _userData = null;
      notifyListeners();
    }
  }

  /// Save user data
  Future<void> saveUserData(UserData userData) async {
    try {
      await _userOperation.writeUserData(userData);
      _userData = userData;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  /// Update user data for a specific user or the current user if userId is null
  Future<void> updateUserData(Map<String, dynamic> updates,
      [String? userId]) async {
    try {
      // 현재 로그인된 유저의 ID를 가져옴
      final currentUserId = userId ?? FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('User ID is null and no user is logged in.');
      }

      // 데이터 업데이트
      await _userOperation.updateUserData(currentUserId, updates);

      // 업데이트된 데이터 다시 가져오기
      _userData = await _userOperation.readUserData(currentUserId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user data: $e');
    }
  }
}
