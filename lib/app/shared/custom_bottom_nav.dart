import 'package:flutter/material.dart';

import 'nav_item.dart';

import '../screens/create/create_screen_page.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111317),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: NavItem(
              icon: Icons.home_rounded,
              label: 'HOME',
              isActive: currentIndex == 0,
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.bolt_rounded,
              label: 'SOCIAL',
              isActive: currentIndex == 1,
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.add_circle,
              label: 'CREATE',
              isCenter: true,
              isActive: currentIndex == 2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateScreenPage(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.groups_rounded,
              label: 'GROUPS',
              isActive: currentIndex == 3,
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.person_rounded,
              label: 'PROFILE',
              isActive: currentIndex == 4,
            ),
          ),
        ],
      ),
    );
  }
}