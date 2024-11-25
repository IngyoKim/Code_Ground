import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';
import 'package:code_ground/src/services/database/operations/user_operation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth 사용

class UserViewModel with ChangeNotifier {
  final UserOperation _userOperation = UserOperation();
  UserData? _currentUserData;
  UserData? _otherUserData;

  UserData? get currentUserData => _currentUserData;
  UserData? get otherUserData => _otherUserData;

  /// 현재 로그인된 유저의 데이터 가져오기
  Future<void> fetchCurrentUserData() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('No user is currently logged in.');
      }

      _currentUserData = await _userOperation.readUserData(currentUserId);

      if (_currentUserData == null) {
        final User? firebaseUser = FirebaseAuth.instance.currentUser;

        _currentUserData = UserData(
          uid: currentUserId,
          name: firebaseUser?.displayName ?? 'Guest',
          email: firebaseUser?.email ?? '',
          photoUrl: firebaseUser?.photoURL ?? '',
          nickname: '',
          role: 'member',
        );

        await _userOperation.writeUserData(_currentUserData!);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching current user data: $e');
      _currentUserData = null;
      notifyListeners();
    }
  }

  /// 특정 ID의 유저 데이터 가져오기 (다른 유저)
  Future<void> fetchOtherUserData(String userId) async {
    try {
      _otherUserData = await _userOperation.readUserData(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching other user data: $e');
      _otherUserData = null;
    }
  }

  /// 다른 유저 데이터 초기화
  void clearOtherUserData() {
    _otherUserData = null;
    notifyListeners();
  }
}
