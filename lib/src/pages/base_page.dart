import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                      );
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
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const MainPage()),
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
