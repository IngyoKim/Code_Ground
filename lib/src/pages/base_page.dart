import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oss_qbank/src/pages/main_page.dart';
import 'package:oss_qbank/src/services/kakao_login.dart';
import 'package:oss_qbank/src/view_models/login_page_model.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final LoginPageModel _loginPageModel = LoginPageModel(KakaoLogin());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ElevatedButton(
                child: const Text("Kakao"),
                onPressed: () async {
                  await _loginPageModel.login();
                },
              );
            }
            return const MainPage();
          },
        ),
      ),
    );
  }
}
