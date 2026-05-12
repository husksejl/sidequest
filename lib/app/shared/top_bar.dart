import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.showSettings = true,
    this.showBackButton = false,
  });

  final bool showSettings;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/LOGO.png',
            height: 34,
          ),

          if (showBackButton)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 20,
              ),
            )

          else if (showSettings)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: const Icon(
                Icons.settings,
                color: Colors.white70,
                size: 24,
              ),
            )

          else
            const SizedBox(width: 24),
        ],
      ),
    );
  }
}