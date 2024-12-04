import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import 'package:code_ground/src/services/auth/social_login.dart';
import 'package:code_ground/src/services/auth/firebase_auth_data.dart';

class KakaoLogin implements SocialLogin {
  // Firebase 인증 객체
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Firebase 커스텀 토큰 생성에 필요한 클래스
  final FirebaseAuthData _firebaseAuthData = FirebaseAuthData();

  @override
  //로그인 타입 지정 (카카오)
  String loginType = "Kakao";

  @override
  Future<User?> login() async {
    try {
      /// Choose login method depending on KakaoTalk installation
      if (await kakao.isKakaoTalkInstalled()) {
        debugPrint("KakaoTalk is installed.");
        try {
          //KakaoTalk을 이용한 로그인
          await kakao.UserApi.instance.loginWithKakaoTalk();
          debugPrint("Successed to login with KakaoTalk.");
        } catch (error) {
          debugPrint("Fail to login with KakaoTalk.\n$error");
        }
      } else {
        debugPrint("KakaoTalk isn't installed.");
        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          debugPrint("Successed to login with Kakao.");
        } catch (error) {
          debugPrint("Fail to login with Kakao.\n$error");
        }
      }

      /// Retrieve Kakao user information
      final user = await kakao.UserApi.instance.me();

      /// Request Firebase custom token creation
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

      /// Firebase login
      UserCredential userCredential =
          await _auth.signInWithCustomToken(customToken);
      await _auth.currentUser?.reload();

      /// Update user information
      return userCredential.user;
    } catch (error) {
      debugPrint("Kakao login failed. $error");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      debugPrint("Attempting to unlink Kakao account...");
      await kakao.UserApi.instance.unlink();
      debugPrint("Successfully unlinked Kakao account.");
    } catch (error) {
      debugPrint("Failed to unlink Kakao account: $error");
    }

    try {
      debugPrint("Attempting to sign out from Firebase...");
      await _auth.signOut();
      debugPrint("Successfully signed out from Firebase.");
    } catch (error) {
      debugPrint("Failed to sign out from Firebase: $error");
    }
  }
}
