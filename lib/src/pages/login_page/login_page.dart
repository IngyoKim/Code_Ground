import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/components/loading_indicator.dart';
import 'package:code_ground/src/pages/login_page/widgets/login_button.dart';
import 'package:code_ground/src/pages/login_page/widgets/login_header.dart';
import 'package:code_ground/src/pages/login_page/widgets/login_footer.dart';

import 'package:code_ground/src/services/auth/google_login.dart';
import 'package:code_ground/src/services/auth/kakao_login.dart';
import 'package:code_ground/src/view_models/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() => _isLoading = isLoading);
    }
  }

  Future<void> tryLogin({
    required BuildContext context,
    required Future<void> Function() loginAction,
    required void Function(bool) setLoading,
  }) async {
    setLoading(true);
    try {
      await loginAction();
    } catch (error) {
      debugPrint("로그인에 실패했습니다: $error");
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const LoadingIndicator(isFetching: true)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const LoginHeader(),
                  const SizedBox(height: 40),
                  LoginButton(
                    label: 'Continue with Kakao',
                    logoPath: 'assets/logo/KakaoTalk_logo.png',
                    onTap: () async {
                      loginViewModel.setLoginType(KakaoLogin());
                      await tryLogin(
                        context: context,
                        loginAction: loginViewModel.login,
                        setLoading: _setLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  LoginButton(
                    label: 'Continue with Google',
                    logoPath: 'assets/logo/Google_logo.png',
                    onTap: () async {
                      loginViewModel.setLoginType(GoogleLogin());
                      await tryLogin(
                        context: context,
                        loginAction: loginViewModel.login,
                        setLoading: _setLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  const LoginFooter(),
                ],
              ),
      ),
    );
  }
}
