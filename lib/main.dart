import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'l10n/app_localizations.dart';

import 'app/screens/home_screen/home_screen.dart';
import 'app/screens/onboarding/onboarding_page.dart';
import 'app/screens/signup/signup_page.dart';
import 'app/screens/login/login_page.dart';
import 'app/screens/settings/settings_page.dart';
import 'app/screens/splash_screen/splash_screen_page.dart';
import 'app/shared/services/theme_service.dart';
import 'app/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  ThemeService.useSystemTheme();

  runApp(const SideQuestApp());
}

class SideQuestApp extends StatelessWidget {
  const SideQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'SideQuest',

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('en'),
            Locale('de'),
          ],

          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,

          routes: {
            SettingsScreen.routeName: (context) => const SettingsScreen(),
            CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
          },

          home: const SplashScreenPage(),
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  void _goToSignup(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF18D7FF),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const _HomeWithSavedAppearance();
        }

        return OnboardingPage(
          onFinished: (context) {
            _goToSignup(context);
          },
        );
      },
    );
  }
}

class _HomeWithSavedAppearance extends StatefulWidget {
  const _HomeWithSavedAppearance();

  @override
  State<_HomeWithSavedAppearance> createState() =>
      _HomeWithSavedAppearanceState();
}

class _HomeWithSavedAppearanceState extends State<_HomeWithSavedAppearance> {
  late final Future<void> _loadAppearanceFuture;

  @override
  void initState() {
    super.initState();
    _loadAppearanceFuture = _loadSavedAppearance();
  }

  Future<void> _loadSavedAppearance() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ThemeService.useSystemTheme();
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final data = doc.data();
    final settings = data?['settings'];

    if (settings is Map<String, dynamic>) {
      final appearanceMode = settings['appearanceMode'];

      if (appearanceMode is String) {
        ThemeService.setThemeMode(
          ThemeService.modeFromString(appearanceMode),
        );
        return;
      }

      // fallback für alte gespeicherte lightMode-Werte
      final oldLightMode = settings['lightMode'];

      if (oldLightMode is bool) {
        ThemeService.setThemeMode(
          oldLightMode ? ThemeMode.light : ThemeMode.dark,
        );
        return;
      }
    }

    ThemeService.useSystemTheme();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadAppearanceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF18D7FF),
              ),
            ),
          );
        }

        return const HomeScreen();
      },
    );
  }
}