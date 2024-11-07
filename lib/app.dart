import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/base_page.dart';

import 'src/pages/base_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title', // 앱 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 기본 테마 색상
      ),
      home: const BasePage(), // 베이스 화면 설정
    );
  }
}
