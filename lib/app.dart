import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:code_ground/src/pages/base_page.dart';
import 'package:code_ground/src/view_models/login_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(context.toString());
    return MultiProvider(
      // MultiProvider를 사용하여 여러 Provider를 등록
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            debugPrint("LoginViewModel 생성됨");
            return LoginViewModel();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Your App Title', // 앱 제목
        theme: ThemeData(
          primarySwatch: Colors.blue, // 기본 테마 색상
        ),
        home: const BasePage(), // 기본 홈 화면 설정
      ),
    );
  }
}
