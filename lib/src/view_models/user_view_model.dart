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

  get userData => null;

  get nickname => _currentUserData!.nickname;

  String get uid => uid;

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
    } catch (error) {
      debugPrint('Error fetching current user data: $error');
      _currentUserData = null;
      notifyListeners();
    }
  }

  /// 특정 ID의 유저 데이터 가져오기 (다른 유저)
  Future<void> fetchOtherUserData(String uid) async {
    try {
      _otherUserData = await _userOperation.readUserData(uid);
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching other user data: $error');
      _otherUserData = null;
    }
  }

  /// 닉네임 업데이트
  Future<void> updateNickname(String nickname) async {
    // _currentUserData 객체의 nickname 갱신
    if (_currentUserData != null) {
      _currentUserData!.nickname = nickname;
    }

    // Firestore나 DB에 저장하는 작업을 처리
    await _userOperation.updateUserData({'nickname': nickname});

    // 상태 갱신 후, 화면을 다시 렌더링
    notifyListeners();
  }

  /// 다른 유저 데이터 초기화
  void clearOtherUserData() {
    _otherUserData = null;
    notifyListeners();
  }
}
