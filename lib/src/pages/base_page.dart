import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oss_qbank/src/pages/login_page.dart';
import 'package:oss_qbank/src/pages/main_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            debugPrint("authStateChanges snapshot: ${snapshot.data}");

            if (!snapshot.hasData) {
              debugPrint("No user logged in. Showing LoginPage.");
              return const LoginPage();
            }

            debugPrint("User is logged in. Showing MainPage.");
            return const MainPage();
          },
        ),
      ),
    );
  }
}
