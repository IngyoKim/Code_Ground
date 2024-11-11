import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/logins/social_login.dart';
import 'package:code_ground/src/services/logins/login_preference.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginPreference _loginPreference = LoginPreference();
  SocialLogin? _socialLogin;
  User? get user => FirebaseAuth.instance.currentUser;

  LoginViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    _socialLogin = await _loginPreference.getLoginType();
    notifyListeners();
  }

  Future<void> setLoginType(SocialLogin socialLogin) async {
    _socialLogin = socialLogin;
    await _loginPreference.setLoginType(socialLogin);
    notifyListeners();
  }

  Future<void> login() async {
    if (_socialLogin == null) {
      debugPrint("Login type not selected.");
      return;
    }

    await _socialLogin!.login();
    await FirebaseAuth.instance.currentUser?.reload();
    notifyListeners();
  }

  Future<void> logout() async {
    if (_socialLogin != null) {
      await _socialLogin!.logout();
      await _loginPreference.clearPreferences(); // 로그인 데이터 초기화
      _socialLogin = null;
      notifyListeners();
    }
  }
}
