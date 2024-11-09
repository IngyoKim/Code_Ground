import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:oss_qbank/src/services/social_login.dart';
import 'firebase_auth_data.dart';
import 'dart:convert';

class KakaoLogin implements SocialLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthData _firebaseAuthData = FirebaseAuthData();

  @override
  Future<User?> login() async {
    try {
      // 카카오톡 설치 여부에 따라 로그인 방식 선택
      if (await kakao.isKakaoTalkInstalled()) {
        await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        await kakao.UserApi.instance.loginWithKakaoAccount();
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
      return userCredential.user;
    } catch (error) {
      debugPrint("Kakao login failed. $error");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await kakao.UserApi.instance.logout();
    } catch (error) {
      debugPrint("Logout failed: $error");
    }
  }
}
