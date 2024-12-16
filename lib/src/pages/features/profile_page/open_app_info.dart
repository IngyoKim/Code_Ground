import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/components/logout_dialog.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';

import 'package:code_ground/src/pages/app_info/setting_page.dart';
import 'package:code_ground/src/pages/app_info/about_page.dart';
import 'package:code_ground/src/pages/app_info/help_page.dart';
import 'package:code_ground/src/pages/app_info/faq_page.dart';

void openAppInfo(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Application Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingPage(
                      initialNickname: '',
                      role:
                          context.read<UserViewModel>().currentUserData?.role ??
                              'member',
                      nickname: context
                              .read<UserViewModel>()
                              .currentUserData
                              ?.nickname ??
                          'Guest',
                      userData: context.read<UserViewModel>().currentUserData,
                      friendData: context
                              .read<UserViewModel>()
                              .currentUserData
                              ?.friendCode ??
                          '',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HelpPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FAQPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.power_off),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                showLogoutDialog(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
