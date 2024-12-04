import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:code_ground/src/services/auth/social_login.dart';
import 'package:code_ground/src/services/auth/login_preference.dart';

class LoginViewModel extends ChangeNotifier {
  //로그인 타입을 저장하고 관리하는 클레스
  final LoginPreference _loginPreference = LoginPreference();
  //현재 로그인 방식(예: Google, kakao)
  SocialLogin? _socialLogin;
  //현재 로그인된 사용자 정보
  User? user;
  //생성자: 초기화 메서드 호출
  LoginViewModel() {
    _initialize();
  }
  //초기화: 저장된 로그인 타입을 불러옴
  Future<void> _initialize() async {
    _socialLogin = await _loginPreference.getLoginType();
    notifyListeners();
  }

  //로그인 타입 설정 및 저장
  Future<void> setLoginType(SocialLogin socialLogin) async {
    _socialLogin = socialLogin;

    /// Save the selected login type to preferences.
    await _loginPreference.setLoginType(socialLogin);
    notifyListeners();
  }

  //로그인 프로세스 실행
  Future<void> login() async {
    if (_socialLogin == null) {
      debugPrint("Login type not selected.");
      return;
    }
    // 소셜 로그인 프로세스 실행
    user = await _socialLogin!.login();
    // 사용자 ID 출력(디버깅용)
    debugPrint("User Id: ${user?.uid}");
    await FirebaseAuth.instance.currentUser?.reload();
    notifyListeners();
  }

  Future<void> logout() async {
    if (_socialLogin != null) {
      await _socialLogin!.logout();
      await FirebaseAuth.instance.currentUser?.reload();
      await FirebaseFirestore.instance.clearPersistence();
      await _loginPreference.clearPreferences();
      _socialLogin = null;
      notifyListeners();
    }
  }
}
