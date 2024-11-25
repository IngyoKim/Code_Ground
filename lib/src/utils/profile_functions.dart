import 'package:flutter/material.dart';
import 'package:code_ground/src/pages/questions/question_state_page.dart';
import 'package:code_ground/src/pages/app_info/setting_page.dart';
import 'package:code_ground/src/pages/app_info/about_page.dart';
import 'package:code_ground/src/pages/app_info/help_page.dart';
import 'package:code_ground/src/pages/app_info/faq_page.dart';
import 'package:code_ground/src/components/logout_dialog.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';

void navigateToQuestionStatePage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const QuestionStatePage(),
    ),
  );
}

void navigateToSettingPage(BuildContext context, UserViewModel userViewModel) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SettingPage(
        nickname: userViewModel.userData?.nickname ?? 'Guest',
        role: userViewModel.userData?.isAdmin ?? false,
        initialNickname: 'Guest',
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
