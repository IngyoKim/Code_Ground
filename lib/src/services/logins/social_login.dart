import 'package:firebase_auth/firebase_auth.dart';

/// Social Login
abstract class SocialLogin {
  Future<User?> login();
  Future<void> logout();
}
