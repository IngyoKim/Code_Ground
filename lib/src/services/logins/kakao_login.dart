import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import 'package:code_ground/src/services/logins/social_login.dart';
import 'package:code_ground/src/services/logins/firebase_auth_data.dart';

/// Kakao Login
class KakaoLogin implements SocialLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthData _firebaseAuthData = FirebaseAuthData();

  @override
  String loginType = "Kakao";

  @override
  Future<User?> login() async {
    try {
      // 카카오톡 설치 여부에 따라 로그인 방식 선택
      if (await kakao.isKakaoTalkInstalled()) {
        debugPrint("KakaoTalk is installed.");
        try {
          await kakao.UserApi.instance.loginWithKakaoTalk();
          debugPrint("Successed to login with Kakao.");
        } catch (error) {
          debugPrint("Fail to login with Kakao.\n$error");
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

      // 카카오 사용자 정보 가져오기
      final user = await kakao.UserApi.instance.me();

      // Firebase 커스텀 토큰 생성 요청
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

      // Firebase 로그인
      UserCredential userCredential =
          await _auth.signInWithCustomToken(customToken);
      await _auth.currentUser?.reload(); // 사용자 정보 갱신
      return userCredential.user;
    } catch (error) {
      debugPrint("Kakao login failed. $error");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      debugPrint("Kakao 연결 끊기 시도 중...");
      await kakao.UserApi.instance.unlink();
      debugPrint("Kakao 연결 끊기 성공");
    } catch (error) {
      debugPrint("Kakao 연결 끊기 실패: $error");
    }

    try {
      debugPrint("Firebase 로그아웃 시도 중...");
      await _auth.signOut();
      debugPrint("Firebase 로그아웃 성공");
    } catch (error) {
      debugPrint("Firebase 로그아웃 실패: $error");
    }
  }
}
