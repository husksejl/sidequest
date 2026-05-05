import 'package:flutter/material.dart';

import 'nav_item.dart';

import '../screens/home_screen/home_screen.dart';
import '../screens/social_hub/social_hub_page.dart';
import '../screens/create/create_screen_page.dart';
import '../screens/group_challenge_discovery/group_challenge_discovery_page.dart';
import '../screens/own_profile/own_profile_page.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    this.currentIndex = 0,
  });

  void _navigateToPage(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const SocialHubPage();
        break;
      case 2:
        page = const CreateScreenPage();
        break;
      case 3:
        page = const GroupChallengeDiscoveryPage();
        break;
      case 4:
        page = const OwnProfilePage();
        break;
      default:
        page = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

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
              onTap: () => _navigateToPage(context, 0),
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.bolt_rounded,
              label: 'SOCIAL',
              isActive: currentIndex == 1,
              onTap: () => _navigateToPage(context, 1),
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.add_circle,
              label: 'CREATE',
              isCenter: true,
              isActive: currentIndex == 2,
              onTap: () => _navigateToPage(context, 2),
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.groups_rounded,
              label: 'GROUPS',
              isActive: currentIndex == 3,
              onTap: () => _navigateToPage(context, 3),
            ),
          ),
          Expanded(
            child: NavItem(
              icon: Icons.person_rounded,
              label: 'PROFILE',
              isActive: currentIndex == 4,
              onTap: () => _navigateToPage(context, 4),
            ),
          ),
        ],
      ),
    );
  }
}