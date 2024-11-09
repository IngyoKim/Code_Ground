import 'package:flutter/material.dart';
import 'package:oss_qbank/src/services/kakao_login.dart';
import 'package:oss_qbank/src/view_models/login_page_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Kakao"),
      onPressed: () async {
        final loginPageModel =
            Provider.of<LoginPageModel>(context, listen: false);
        loginPageModel.setLoginType(KakaoLogin());
        await loginPageModel.login();
      },
    );
  }
}
