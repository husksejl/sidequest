import 'package:flutter/material.dart';

import 'nav_item.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

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
        children: const [
          Expanded(
            child: NavItem(
              icon: Icons.home_rounded,
              label: 'HOME',
              isActive: true,
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.dynamic_feed_rounded,
              label: 'FEED',
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.add_circle,
              label: 'CREATE',
              isCenter: true,
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.groups_rounded,
              label: 'GROUPS',
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.person_rounded,
              label: 'PROFILE',
            ),
          ),
        ],
      ),
    );
  }
}