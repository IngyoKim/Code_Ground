import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:code_ground/src/services/auth/social_login.dart';
import 'package:code_ground/src/services/auth/login_preference.dart';

//login
class LoginViewModel extends ChangeNotifier {
  final LoginPreference _loginPreference = LoginPreference();
  SocialLogin? _socialLogin;
  User? user;

  LoginViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    _socialLogin = await _loginPreference.getLoginType();
    notifyListeners();
  }

  Future<void> setLoginType(SocialLogin socialLogin) async {
    _socialLogin = socialLogin;

    // Save the selected login type to preferences.
    await _loginPreference.setLoginType(socialLogin);
    notifyListeners();
  }

  Future<void> login() async {
    if (_socialLogin == null) {
      debugPrint("Login type not selected.");
      return;
    }

    user = await _socialLogin!.login();
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
//login version