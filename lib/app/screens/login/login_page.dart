import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../home_screen/home_screen.dart';
import '../signup/signup_page.dart';
import '../login/models/login_form_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';
  static const Color bgColor = Color(0xFF050608);

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 34),
              Text(
                l10n.welcomeBack,
                style: const TextStyle(
                  color: Color(0xFF18D7FF),
                  fontSize: 13,
                  letterSpacing: 4.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.loginToSideQuest,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  height: 0.95,
                  letterSpacing: -1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.loginSubtitle,
                style: const TextStyle(
                  color: Color(0xFF9AA0AA),
                  fontSize: 15,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 26),
              LoginFormCard(
                onLoginSuccess: () {
                  _goToHome(context);
                },
                onCreateProfileTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  l10n.loginFooter,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.34),
                    fontSize: 13,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
