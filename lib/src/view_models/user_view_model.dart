import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/models/user_data.dart';
import 'package:code_ground/src/services/database/user_manager.dart';

class UserViewModel with ChangeNotifier {
  final UserManager _userManager = UserManager();
  UserData? _currentUserData;
  UserData? _otherUserData;

  UserData? get currentUserData => _currentUserData;
  UserData? get otherUserData => _otherUserData;

  /// `uid`를 해싱하여 12자리 고유 친구 코드 생성
  String generateFriendCode(String uid) {
    final bytes = utf8.encode(uid); // UID를 바이트로 변환
    final hash = sha256.convert(bytes); // SHA-256 해싱
    return hash.toString().substring(0, 12).toUpperCase(); // 상위 12자만 사용
  }

  /// 현재 로그인된 유저의 데이터 가져오기
  Future<void> fetchCurrentUserData() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('No user is currently logged in.');
      }

      // 데이터베이스에서 현재 유저 데이터 가져오기
      _currentUserData = await _userManager.readUserData();

      // 유저 데이터가 없을 경우 초기화
      if (_currentUserData == null) {
        final User? firebaseUser = FirebaseAuth.instance.currentUser;

        // 새로운 친구 초대 코드 생성
        final generatedFriendCode = generateFriendCode(currentUserId);

        // 유저 데이터 초기화
        _currentUserData = UserData(
          uid: currentUserId,
          name: firebaseUser?.displayName ?? 'Guest',
          email: firebaseUser?.email ?? '',
          photoUrl: firebaseUser?.photoURL ?? '',
          nickname: firebaseUser?.displayName ?? 'Guest',
          role: 'member',
          friendCode: generatedFriendCode,
          friends: [],
        );

        // 데이터베이스에 저장
        await _userManager.writeUserData(_currentUserData!);
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
      _otherUserData = await _userManager.readUserData(uid);
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching other user data: $error');
      _otherUserData = null;
    }
  }

  /// 닉네임 업데이트
  Future<void> updateNickname(String nickname) async {
    if (_currentUserData != null) {
      _currentUserData!.nickname = nickname;
    }

    await _userManager.updateUserData({'nickname': nickname});

    notifyListeners();
  }

  /// 친구 추가 메서드
  Future<void> addFriend(String friendCode) async {
    try {
      if (_currentUserData == null) {
        throw Exception('Current user data is not loaded.');
      }

      final users = await _userManager.fetchUsers();

      final friendUser = users.firstWhere(
        (user) => user.friendCode == friendCode,
        orElse: () => throw Exception('No user found with this friend code.'),
      );

      if (friendUser.uid == _currentUserData!.uid) {
        throw Exception('You cannot add yourself as a friend.');
      }

      if (!_currentUserData!.friends.contains(friendUser.uid)) {
        _currentUserData!.friends.add(friendUser.uid);
        await _userManager
            .updateUserData({'friends': _currentUserData!.friends});
      }

      if (!friendUser.friends.contains(_currentUserData!.uid)) {
        friendUser.friends.add(_currentUserData!.uid);
        await _userManager.updateUserData({'friends': friendUser.friends},
            uid: friendUser.uid);
      }

      debugPrint('[addFriend] Successfully added friend: ${friendUser.uid}');
      notifyListeners();
    } catch (error) {
      debugPrint('[addFriend] Error adding friend: $error');
      throw Exception('Failed to add friend: $error');
    }
  }

  void clearOtherUserData() {
    _otherUserData = null;
    notifyListeners();
  }
}
