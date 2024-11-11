import 'package:shared_preferences/shared_preferences.dart';
import 'package:code_ground/src/services/logins/social_login.dart';
import 'package:code_ground/src/services/logins/kakao_login.dart';
import 'package:code_ground/src/services/logins/google_login.dart';

class LoginPreference {
  static const String loginTypeKey = 'loginType';

  /// 로그인 타입을 SharedPreferences에 저장
  Future<void> setLoginType(SocialLogin socialLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(loginTypeKey, socialLogin.loginType);
  }

  /// SharedPreferences에서 로그인 타입을 불러와 SocialLogin 객체로 반환
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

  /// SharedPreferences 전체 초기화 (로그아웃 시 호출)
  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 전체 초기화
  }
}
