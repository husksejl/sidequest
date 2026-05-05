import 'package:flutter/material.dart';

import 'app/screens/splash_screen/splash_screen_page.dart';

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
      ),
      home: const SplashScreenPage(),
    );
  }
}