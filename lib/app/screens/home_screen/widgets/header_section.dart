import 'package:flutter/material.dart';

import '../../settings_screen/settings_screen.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/LOGO.png',
          height: 50,
        ),

        const Spacer(),

        IconButton(
          tooltip: 'Settings',
          onPressed: () => Navigator.pushNamed(context, SettingsScreen.routeName),
          icon: const Icon(
            Icons.settings_rounded,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
