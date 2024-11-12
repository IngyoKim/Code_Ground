import 'package:code_ground/src/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void showLogoutDialog(BuildContext context) {
  final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

  showDialog(
    context: context,
    barrierDismissible: false, // 바깥 클릭으로 팝업 닫히지 않게
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('로그아웃'),
        content: Text('로그아웃 후 앱이 종료됩니다. 정말 종료하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // 취소
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await loginViewModel.logout();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(true); // "확인" 클릭 시 팝업 닫기
              SystemNavigator.pop(); // 앱 종료
            },
            child: Text('확인'),
          ),
        ],
      );
    },
  );
}
