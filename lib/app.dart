import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/pages/base_page.dart';
import 'package:code_ground/src/view_models/login_view_model.dart';

import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/question_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';
import 'package:code_ground/src/view_models/category_view_model.dart';
import 'package:code_ground/src/services/ads/rewarded_ad_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(context.toString());
    return MultiProvider(
      /// Registers multiple providers using MultiProvider.
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ProgressViewModel()),
        ChangeNotifierProvider(create: (_) => QuestionViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => RewardedAdService()),
      ],
      child: MaterialApp(
        /// App title.
        title: 'Code Ground',
        theme: ThemeData(
          /// Default theme color.
          primarySwatch: Colors.blue,
        ),

        /// Removes the debug banner.
        debugShowCheckedModeBanner: false,

        /// Sets the default home screen.
        home: const BasePage(),
      ),
    );
  }
}
