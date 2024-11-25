import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:code_ground/src/services/logins/social_login.dart';

class GoogleLogin implements SocialLogin {
  @override
  String loginType = "Google";

  @override
  Future<User?> login() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        debugPrint("Google login was cancelled by the user.");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception(
            "Google login failed: Missing access token or ID token");
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("Successed to login with Google.");
      return userCredential.user;
    } catch (error) {
      debugPrint("Google Sign-In Error: $error");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      debugPrint("Google 로그아웃 시도 중...");
      await GoogleSignIn().signOut();
      debugPrint("Google 로그아웃 성공");
    } catch (error) {
      debugPrint("Google 로그아웃 실패: $error");
    }

    try {
      debugPrint("Firebase 로그아웃 시도 중...");
      await FirebaseAuth.instance.signOut();
      debugPrint("Firebase 로그아웃 성공");
    } catch (error) {
      debugPrint("Firebase 로그아웃 실패: $error");
    }
  }
}
