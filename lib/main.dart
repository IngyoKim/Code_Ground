import 'package:flutter/material.dart';

import 'package:code_ground/app.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // flutter 코어엔진 초기화

  // Kakao SDK와 Firebase도 초기화
  KakaoSdk.init(nativeAppKey: '1f855e753726dc188a4ff1be335db17e');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App()); // 앱 실행
}
