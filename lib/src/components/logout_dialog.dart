import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/login_view_model.dart';

void showLogoutDialog(BuildContext context) {
  final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

  showDialog(
    context: context,
    barrierDismissible: false,

    /// Prevent the popup from closing by clicking outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          '로그아웃',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '로그아웃하시면 앱이 종료됩니다.\n계속 진행하시겠어요?',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);

              /// Close dialog on "Cancel"
            },
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await loginViewModel.logout();

              /// ignore: use_build_context_synchronously
              Navigator.of(context).pop(true);

              /// Close dialog on "Confirm"
              SystemNavigator.pop();

              /// Close the app
            },
            child: const Text(
              '확인',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}
