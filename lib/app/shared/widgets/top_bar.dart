import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.appIconColor,
                size: 20,
              ),
            )

          else if (showSettings)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Icon(
                Icons.settings,
                color: context.appIconColor,
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