import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:oss_qbank/src/services/firebase_auth_data.dart';
import 'package:oss_qbank/src/services/social_login.dart';

class LoginPageModel extends ChangeNotifier {
  final _firebaseAuthData = FirebaseAuthData();
  final SocialLogin _socialLogin;
  bool isLogined = false; // 로그인 상태
  bool isLoading = true; // 로딩 상태
  kakao.User? user;

  LoginPageModel(this._socialLogin);

  Future<void> login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();
      final token = await _firebaseAuthData.createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount?.profile?.nickname,
        'email': user!.kakaoAccount?.email,
        'photoURL': user!.kakaoAccount?.profile?.profileImageUrl!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);
    }
  }

  Future<void> logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }
}
