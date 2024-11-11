import 'package:firebase_auth/firebase_auth.dart';

abstract class SocialLogin {
  late String loginType;
  Future<User?> login();
  Future<void> logout();
}
