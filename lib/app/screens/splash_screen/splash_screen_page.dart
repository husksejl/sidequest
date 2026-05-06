import 'package:flutter/material.dart';

import '../home_screen/home_screen.dart';
import '../onboarding/onboarding_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    rotationAnimation = Tween<double>(
      begin: -0.04,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 520),
          reverseTransitionDuration: const Duration(milliseconds: 360),
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnboardingPage(
              onFinished: (context) {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 520),
                    reverseTransitionDuration:
                    const Duration(milliseconds: 360),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const HomeScreen();
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
            );
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
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Opacity(
              opacity: fadeAnimation.value,
              child: Transform.rotate(
                angle: rotationAnimation.value,
                child: Transform.scale(
                  scale: scaleAnimation.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10C7BE).withOpacity(0.22),
                          blurRadius: 70,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: const Color(0xFFFF6358).withOpacity(0.18),
                          blurRadius: 90,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/LOGO-icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}