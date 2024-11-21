import 'package:shared_preferences/shared_preferences.dart';
import 'package:code_ground/src/services/logins/social_login.dart';
import 'package:code_ground/src/services/logins/kakao_login.dart';
import 'package:code_ground/src/services/logins/google_login.dart';

class LoginPreference {
  static const String loginTypeKey = 'loginType';

  /// Save login type in SharedPreferences
  Future<void> setLoginType(SocialLogin socialLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(loginTypeKey, socialLogin.loginType);
  }

  /// Load login type from SharedPreferences and return as a SocialLogin object
  Future<SocialLogin?> getLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTypeString = prefs.getString(loginTypeKey);

    switch (loginTypeString) {
      case 'Kakao':
        return KakaoLogin();
      case 'Google':
        return GoogleLogin();
      default:
        return null;
    }
  }

  /// Clear all data in SharedPreferences
  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    /// Clear all data
    await prefs.clear();
  }
}
