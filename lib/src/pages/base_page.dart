import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ElevatedButton(
                    onPressed: () async {
                      await loginViewModel.login();
                      if (loginViewModel.isLogined) {
                        // 로그인 성공 시 MainView로 이동
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const MainView()),
                        );
                      }
                    },
                    child: Image.asset(
                        'assets/images/kakao_login_medium_narrow.png'),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        await loginViewModel.logout();
                        // 로그아웃 후 다시 LoginView로 이동
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginView()),
                        );
                      },
                      child: const Text('디자인 뭐같네.. 안해 때려쳐'),
                    ),
                  ],
                );
              })),
    );
  }
}
