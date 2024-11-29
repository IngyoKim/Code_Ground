import 'package:code_ground/src/services/database/operations/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

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
  Future<void> updateUserData(Map<String, dynamic> updates) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      debugPrint('[readUserData] No user is currently logged in.');
      throw Exception('No user is currently logged in.');
    }
    String path = '$basePath/$uid';
    debugPrint('[updateUserData] Updating user data at path: $path');
    try {
      await _dbService.updateDB(path, updates);
      debugPrint('[updateUserData] Successfully updated user data at $path');
    } catch (error) {
      debugPrint('[updateUserData] Error updating user data: $error');
      rethrow;
    }
  }

  Future<void> addFriend(String friendCode) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      debugPrint('[addFriend] No user is currently logged in.');
      throw Exception('No user is currently logged in.');
    }

    try {
      // 기존 friend 리스트 가져오기
      final userData = await readUserData();
      if (userData == null) {
        debugPrint('[addFriend] No user data found for current user.');
        throw Exception('User data not found.');
      }

      // 이미 등록된 친구인지 확인
      if (userData.friend.contains(friendCode)) {
        debugPrint(
            '[addFriend] This friend is already registered as a friend: $friendCode');
        return; // 함수 종료
      }

      final allUsersData = await _dbService.readDB(basePath);
      if (allUsersData == null) {
        debugPrint('[addFriend] No users found in the database.');
        throw Exception('No users found in the database.');
      }

      // friendCode가 존재하는 유저 검색
      bool friendExists = false;
      for (var entry in allUsersData.entries) {
        final user = UserData.fromJson(Map<String, dynamic>.from(entry.value));
        if (user.friendCode == friendCode) {
          friendExists = true;
          break;
        }
      }

      if (!friendExists) {
        debugPrint('[addFriend] User not found for friend code: $friendCode');
        return; // 함수 종료
      }

      // friend 리스트에 friendCode 추가
      final updatedFriendList = List<String>.from(userData.friend)
        ..add(friendCode);
      await updateUserData({'friend': updatedFriendList});

      debugPrint(
          '[addFriend] Successfully added friend with code: $friendCode');
    } catch (error) {
      debugPrint('[addFriend] Error adding friend: $error');
      rethrow;
    }
  }
}
