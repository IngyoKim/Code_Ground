import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/app_info/setting_page.dart';
import 'package:code_ground/src/pages/app_info/about_page.dart';
import 'package:code_ground/src/pages/app_info/help_page.dart';
import 'package:code_ground/src/pages/app_info/faq_page.dart';
import 'package:code_ground/src/components/logout_dialog.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';

void navigateToSettingPage(BuildContext context, UserViewModel userViewModel) {
  // userViewModel.currentUserData가 null일 경우 기본값 처리
  final nickname = userViewModel.currentUserData?.nickname ?? 'Guest';
  userViewModel.currentUserData?.role == 'admin'; // 예시로 role을 admin으로 설정

  var role;
  var userData; //만약 문제 생기면 여기 확인하기
  var friendData;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SettingPage(
        nickname: nickname, // null일 경우 'Guest'로 기본값 설정
        initialNickname: nickname, role: role,
        userData: userData,
        friendData: friendData, // initialNickname을 nickname과 동일하게 설정
      ),
    ),
  );
}

void navigateToAboutPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AboutPage(),
    ),
  );
}

void navigateToHelpPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const HelpPage(),
    ),
  );
}

void navigateToFAQPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const FAQPage(),
    ),
  );
}

void showLogoutDialogFunction(BuildContext context) {
  showLogoutDialog(context);
}
