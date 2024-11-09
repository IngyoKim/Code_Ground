import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:oss_qbank/src/services/google_login.dart';
import 'package:oss_qbank/src/services/kakao_login.dart';
import 'package:oss_qbank/src/view_models/login_page_model.dart';

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
      body: Column(
        children: <Widget>[
          ElevatedButton(
            child: const Text("Kakao"),
            onPressed: () async {
              loginPageModel.setLoginType(KakaoLogin());
              await loginPageModel.login();
            },
          ),
          ElevatedButton(
            child: const Text("Google"),
            onPressed: () async {
              loginPageModel.setLoginType(GoogleLogin());
              await loginPageModel.login();
            },
          ),
        ],
      ),
    );
  }
}
