import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oss_qbank/src/services/firebase_auth_data.dart';
import 'package:oss_qbank/src/services/social_login.dart';

class LoginPageModel extends ChangeNotifier {
  final _firebaseAuthData = FirebaseAuthData();
  final SocialLogin _socialLogin;
  bool isLogined = false; // 로그인 상태
  bool isLoading = true; // 로딩 상태
  User? user; // Firebase에서 반환되는 User 객체로 수정

  LoginPageModel(this._socialLogin);

  Future<void> login() async {
    // 로딩 상태 업데이트
    isLoading = true;
    notifyListeners();

    // 소셜 로그인 시도
    user = await _socialLogin.login();
    isLogined = user != null;

    if (isLogined) {
      debugPrint("Logged in as ${user!.displayName}");

      // Firebase User로 로그인한 상태라면 사용자 정보를 출력
      debugPrint("User UID: ${user!.uid}");
      debugPrint("Display Name: ${user!.displayName}");
      debugPrint("Email: ${user!.email}");
    }

    // 로딩 상태 업데이트
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
    notifyListeners();
  }
}
