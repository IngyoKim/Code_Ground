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

  // Hashes 'uid' to generate 12-digit unique friend code
  String generateFriendCode(String uid) {
    final bytes = utf8.encode(uid);

    // Converting UID to Bytes
    final hash = sha256.convert(bytes);

    // SHA-256 hashing
    return hash.toString().substring(0, 12).toUpperCase();

    // Use Top 12 Characters Only
  }

  // Import data from the currently logged-in user
  Future<void> fetchCurrentUserData() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        throw Exception('No user is currently logged in.');
      }

      // Import current user data from database
      _currentUserData = await _userManager.readUserData();

      // Initialize when no user data is available
      if (_currentUserData == null) {
        final User? firebaseUser = FirebaseAuth.instance.currentUser;

        // Create a new friend invitation code
        final generatedFriendCode = generateFriendCode(currentUserId);

        // Initialize user data
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

        // Save to database
        await _userManager.writeUserData(_currentUserData!);
      }
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching current user data: $error');
      _currentUserData = null;
      notifyListeners();
    }
  }

  // Get user data with a specific ID (other users)
  Future<void> fetchOtherUserData(String uid) async {
    try {
      _otherUserData = await _userManager.readUserData(uid);
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching other user data: $error');
      _otherUserData = null;
    }
  }

  // Nickname update
  Future<void> updateNickname(String nickname) async {
    if (_currentUserData != null) {
      _currentUserData!.nickname = nickname;
    }

    await _userManager.updateUserData({'nickname': nickname});

    notifyListeners();
  }

  // How to add friends
  Future<void> addFriend(String friendCode) async {
    try {
      if (_currentUserData == null) {
        throw Exception('Current user data is not loaded.');
      }

      // Import all user data
      final users = await _userManager.fetchUsers();

      // Find the user with friendCode
      final friendUser = users.firstWhere(
        (user) => user.friendCode == friendCode,
        orElse: () => throw Exception('No user found with this friend code.'),
      );

      /// Make sure you're yourself
      if (friendUser.friendCode == _currentUserData!.friendCode) {
        throw Exception('You cannot add yourself as a friend.');
      }

      // Add friendCode to Friends List
      final friendMap = {
        'uid': friendUser.uid,
        'friendCode': friendUser.friendCode,
      };
      if (!_currentUserData!.friends.any((friend) =>
          friend['uid'] == friendMap['uid'] &&
          friend['friendCode'] == friendMap['friendCode'])) {
        _currentUserData!.friends.add(friendMap);
        await _userManager
            .updateUserData({'friends': _currentUserData!.friends});
      }

      // Add the friendCode of the current user to the list of your friends
      final currentUserMap = {
        'uid': _currentUserData!.uid,
        'friendCode': _currentUserData!.friendCode,
      };
      if (!friendUser.friends.any((friend) =>
          friend['uid'] == currentUserMap['uid'] &&
          friend['friendCode'] == currentUserMap['friendCode'])) {
        friendUser.friends.add(currentUserMap);
        await _userManager.updateUserData({'friends': friendUser.friends},
            uid: friendUser.uid);
      }

      debugPrint(
          '[addFriend] Successfully added friend: ${friendUser.friendCode}');
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
