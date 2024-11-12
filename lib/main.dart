import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:code_ground/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
