import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/utils/login_uitils.dart';
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

  @override
  Widget build(BuildContext context) {
    debugPrint(context.toString());
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
                      await tryLogin(
                        context: context,
                        loginAction: loginViewModel.login,
                        setLoading: (loading) => setState(() {
                          _isLoading = loading;
                        }),
                      );
                    },
                    child: const Text("Kakao"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      loginViewModel.setLoginType(GoogleLogin());
                      await tryLogin(
                        context: context,
                        loginAction: loginViewModel.login,
                        setLoading: (loading) => setState(() {
                          _isLoading = loading;
                        }),
                      );
                    },
                    child: const Text("Google"),
                  ),
                ],
              ),
      ),
    );
  }
}
