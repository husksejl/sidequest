import 'package:flutter/material.dart';

import 'app/screens/create_account_screen/create_account_screen.dart';
import 'app/screens/create_screen/create_screen.dart';
import 'app/screens/splash_screen/splash_screen_page.dart';
import 'app/screens/login_screen/login_screen.dart';
import 'app/screens/own_profile_screen/own_profile_screen.dart';
import 'app/screens/settings_screen/settings_screen.dart';

void main() {
  runApp(const SideQuestApp());
}

class SideQuestApp extends StatelessWidget {
  const SideQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SideQuest',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050608),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const SplashScreenPage(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        CreateScreen.routeName: (context) => const CreateScreen(),
        OwnProfileScreen.routeName: (context) => const OwnProfileScreen(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
      },
    );
  }
}
