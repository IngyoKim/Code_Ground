import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:code_ground/app.dart';
import 'package:code_ground/firebase_options.dart';

void main() async {
  /// Initializes the Flutter core engine.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializes Kakao SDK and Firebase.
  KakaoSdk.init(nativeAppKey: 'adee6c4e15930c7a0270ee23244fb085');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Initializes AdMob
  MobileAds.instance.initialize();

  /// Initializes the Flutter core engine.
  runApp(const App());
}
