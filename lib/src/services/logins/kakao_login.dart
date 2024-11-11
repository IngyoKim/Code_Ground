import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'firebase_auth_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:code_ground/src/services/logins/social_login.dart';

class KakaoLogin implements SocialLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthData _firebaseAuthData = FirebaseAuthData();

  @override
  Future<User?> login() async {
    try {
      // Choose login method depending on KakaoTalk installation
      if (await kakao.isKakaoTalkInstalled()) {
        await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      // Retrieve Kakao user information
      final user = await kakao.UserApi.instance.me();

      // Request to create Firebase custom token
      final response = await _firebaseAuthData.createCustomToken({
        'uid': user.id.toString(),
        'displayName': user.kakaoAccount?.profile?.nickname ?? '',
        'email': user.kakaoAccount?.email ?? '',
        'photoURL': user.kakaoAccount?.profile?.profileImageUrl ?? '',
      });

      final tokenData = jsonDecode(response);
      final customToken = tokenData['token'] ?? '';

      if (customToken.isEmpty) {
        debugPrint("Failed to retrieve custom token.");
        return null;
      }

      // Sign in with Firebase using custom token
      UserCredential userCredential =
          await _auth.signInWithCustomToken(customToken);
      return userCredential.user;
    } catch (error) {
      debugPrint("Kakao login failed. $error");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      debugPrint("Attempting to log out from Firebase.");
      await _auth.signOut();
      debugPrint("Successfully logged out from Firebase.");
    } catch (error) {
      debugPrint("Failed to log out from Firebase: $error");
    }

    try {
      debugPrint("Attempting to log out from Kakao.");
      await kakao.UserApi.instance.logout();
      debugPrint("Successfully logged out from Kakao.");
    } catch (error) {
      debugPrint("Failed to log out from Kakao: $error");
    }
  }
}
