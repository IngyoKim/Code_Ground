import 'package:flutter/material.dart';

Future<void> tryLogin({
  required BuildContext context,
  required Future<void> Function() loginAction,
  required void Function(bool) setLoading,
}) async {
  setLoading(true);
  try {
    await loginAction();
  } catch (error) {
    debugPrint("로그인에 실패했습니다: $error");
  } finally {
    setLoading(false);
  }
}
