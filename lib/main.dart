import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:oss_qbank/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // flutter 코어엔진 초기화

  // Kakao SDK와 Firebase도 초기화
  KakaoSdk.init(nativeAppKey: 'adee6c4e15930c7a0270ee23244fb085');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App()); // 앱 실행
}
