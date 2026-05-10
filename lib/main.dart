import 'package:flutter/material.dart';

import 'app/screens/onboarding/onboarding_page.dart';
import 'app/screens/signup/signup_page.dart';

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
      home: OnboardingPage(
        onFinished: (context) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 520),
              reverseTransitionDuration: const Duration(milliseconds: 360),
              pageBuilder: (context, animation, secondaryAnimation) {
                return const CreateAccountScreen();
              },
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                );

                return FadeTransition(
                  opacity: curvedAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(curvedAnimation),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}