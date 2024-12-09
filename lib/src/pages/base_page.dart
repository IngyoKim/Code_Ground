import 'package:code_ground/notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:code_ground/src/pages/main_page.dart';
import 'package:code_ground/src/pages/login_page/login_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    super.initState();
    FlutterLocalNotification.init();
    Future.delayed(const Duration(seconds: 3), () {
      FlutterLocalNotification.requestNotificationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(context.toString());
    return Scaffold(
      body: Center(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return !snapshot.hasData ? const LoginPage() : const MainPage();
          },
        ),
      ),
    );
  }
}
