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
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white, // 배경색 설정
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 로고 이미지 (크기 조정)
                  Image.asset(
                    'assets/logo/code_ground_logo.png',
                    height: 200, // 로고 크기 키움
                    width: 200,
                  ),
                  const SizedBox(height: 30),
                  // "CODEGROUND" 텍스트
                  const Text(
                    'CODEGROUND',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // 설명 텍스트
                  const Text(
                    '로그인을 위해\nSNS 계정을 연결해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  // 카카오 로그인 버튼
                  _buildLoginButton(
                    label: 'Continue with Kakao',
                    logoPath: 'assets/logo/KakaoTalk_logo.png',
                    onTap: () async {
                      Provider.of<LoginViewModel>(context, listen: false)
                          .setLoginType(KakaoLogin());
                      await tryLogin(
                        context: context,
                        loginAction: loginViewModel.login,
                        setLoading: (loading) {
                          if (mounted) {
                            setState(() {
                              _isLoading = loading;
                            });
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 구글 로그인 버튼
                  _buildLoginButton(
                    label: 'Continue with Google',
                    logoPath: 'assets/logo/Google_logo.png',
                    onTap: () async {
                      Provider.of<LoginViewModel>(context, listen: false)
                          .setLoginType(GoogleLogin());
                      await tryLogin(
                        context: context,
                        loginAction: loginViewModel.login,
                        setLoading: (loading) {
                          if (mounted) {
                            setState(() {
                              _isLoading = loading;
                            });
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  // 하단 텍스트
                  const Text(
                    'CBNU Department of Computer Engineering, 2024',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // 공통 버튼 위젯
  Widget _buildLoginButton({
    required String label,
    required String logoPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoPath,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
