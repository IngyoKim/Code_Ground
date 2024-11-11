import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/services/logins/google_login.dart';
import 'package:code_ground/src/services/logins/kakao_login.dart';
import 'package:code_ground/src/view_models/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _loginWith(LoginViewModel loginViewModel) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await loginViewModel.login();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인에 실패했습니다: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      loginViewModel.setLoginType(KakaoLogin());
                      await _loginWith(loginViewModel);
                    },
                    child: const Text("Kakao"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      loginViewModel.setLoginType(GoogleLogin());
                      await _loginWith(loginViewModel);
                    },
                    child: const Text("Google"),
                  ),
                ],
              ),
      ),
    );
  }
}
