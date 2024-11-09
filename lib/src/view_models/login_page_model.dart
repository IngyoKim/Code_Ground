import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:oss_qbank/src/services/firebase_auth_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:oss_qbank/src/services/social_login.dart';
import 'package:oss_qbank/src/services/kakao_login.dart';
import 'package:oss_qbank/src/services/google_login.dart';

class LoginPageModel extends ChangeNotifier {
  final _firebaseAuthData = FirebaseAuthData();
  SocialLogin? _socialLogin;
  User? user;

  LoginPageModel() {
    _initializeLoginType(); // 앱 시작 시 이전 로그인 타입 설정
  }

  /// 이전 로그인 타입 확인 및 설정
  Future<void> _initializeLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    final loginType = prefs.getString('loginType');

    if (loginType == 'kakao') {
      _socialLogin = KakaoLogin();
    } else if (loginType == 'google') {
      _socialLogin = GoogleLogin();
    }

    /// Firebase 인증 상태가 존재하고, 로그인 타입이 설정되었다면 자동 로그인 시도
    if (FirebaseAuth.instance.currentUser != null && _socialLogin != null) {
      notifyListeners();
    }
  }

  /// 로그인 타입 설정 및 로컬 저장
  void setLoginType(SocialLogin socialLogin) async {
    _socialLogin = socialLogin;
    final prefs = await SharedPreferences.getInstance();

    if (socialLogin is KakaoLogin) {
      await prefs.setString('loginType', 'kakao');
    } else if (socialLogin is GoogleLogin) {
      await prefs.setString('loginType', 'google');
    }

    notifyListeners();
  }

  /// 로그인 함수
  Future<void> login() async {
    if (_socialLogin == null) {
      debugPrint("Login type not selected.");
      return;
    }
    user = await _socialLogin!.login();
    notifyListeners();
  }

  /// 로그아웃 함수
  Future<void> logout() async {
    if (_socialLogin == null) return;

    await _socialLogin!.logout();

    user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loginType');

    notifyListeners();
  }
}
