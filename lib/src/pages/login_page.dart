import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/services/google_login.dart';
import 'package:code_ground/src/services/kakao_login.dart';
import 'package:code_ground/src/view_models/login_page_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final loginPageModel = Provider.of<LoginPageModel>(context, listen: false);
    return Scaffold(
      body: Center(
        // 전체를 가운데 정렬
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 수직 방향 가운데 정렬
          crossAxisAlignment: CrossAxisAlignment.center, // 수평 방향 가운데 정렬
          children: <Widget>[
            ElevatedButton(
              child: const Text("Kakao"),
              onPressed: () async {
                loginPageModel.setLoginType(KakaoLogin());
                await loginPageModel.login();
              },
            ),
            const SizedBox(height: 20), // 버튼 간격
            ElevatedButton(
              child: const Text("Google"),
              onPressed: () async {
                loginPageModel.setLoginType(GoogleLogin());
                await loginPageModel.login();
              },
            ),
          ],
        ),
      ),
    );
  }
}
