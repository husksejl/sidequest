import 'package:flutter/material.dart';

import '../create_account_screen/create_account_screen.dart';
import '../login_screen/login_screen.dart';
import 'widgets/danger_zone_card.dart';
import 'widgets/settings_header.dart';
import 'widgets/settings_profile_card.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_switch_tile.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings';
  static const Color bgColor = Color(0xFF050608);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  bool dailyQuestReminder = true;
  bool streakWarning = true;
  bool privateProfile = false;
  bool allowFriendRequests = true;
  bool locationHints = true;
  bool hapticFeedback = true;
  bool saveUploadedPhotos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsScreen.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SettingsHeader(),
              const SizedBox(height: 22),
              const SettingsProfileCard(
                userName: 'Alex Explorer',
                userHandle: '@alexexplores',
                streak: 5,
                level: 'Rookie Adventurer',
              ),
              const SizedBox(height: 18),
              SettingsSection(
                title: 'ACCOUNT',
                children: [
                  SettingsTile(
                    icon: Icons.person_rounded,
                    title: 'Edit profile',
                    subtitle: 'Name, username, photo and bio',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.mail_rounded,
                    title: 'Email & login',
                    subtitle: 'Manage email, password and sign-in options',
                    onTap: () => Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.person_add_alt_1_rounded,
                    title: 'Create New Profile',
                    subtitle: 'Start A New SideQuest Streak',
                    accentColor: const Color(0xFF18D7FF),
                    onTap: () => Navigator.pushNamed(
                      context,
                      CreateAccountScreen.routeName,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.emoji_events_rounded,
                    title: 'Quest preferences',
                    subtitle: 'Topics, difficulty and daily quest style',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: 'NOTIFICATIONS',
                children: [
                  SettingsSwitchTile(
                    icon: Icons.notifications_rounded,
                    title: 'Push notifications',
                    subtitle: 'Receive updates from SideQuest',
                    value: pushNotifications,
                    onChanged: (value) => setState(() => pushNotifications = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.today_rounded,
                    title: 'Daily SideQuest reminder',
                    subtitle: 'Get reminded when a new quest starts',
                    value: dailyQuestReminder,
                    onChanged: (value) => setState(() => dailyQuestReminder = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Streak warning',
                    subtitle: 'Warn me before my streak expires',
                    value: streakWarning,
                    onChanged: (value) => setState(() => streakWarning = value),
                    accentColor: const Color(0xFFFF8D84),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: 'PRIVACY & SAFETY',
                children: [
                  SettingsSwitchTile(
                    icon: Icons.lock_rounded,
                    title: 'Private profile',
                    subtitle: 'Only approved friends can see your quests',
                    value: privateProfile,
                    onChanged: (value) => setState(() => privateProfile = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.group_add_rounded,
                    title: 'Allow friend requests',
                    subtitle: 'Let other adventurers send requests',
                    value: allowFriendRequests,
                    onChanged: (value) => setState(() => allowFriendRequests = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.location_on_rounded,
                    title: 'Location hints',
                    subtitle: 'Use rough location for nearby quest ideas',
                    value: locationHints,
                    onChanged: (value) => setState(() => locationHints = value),
                    accentColor: const Color(0xFFFF8D84),
                  ),
                  SettingsTile(
                    icon: Icons.visibility_off_rounded,
                    title: 'Blocked accounts',
                    subtitle: 'Review people you have blocked',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: 'APP EXPERIENCE',
                children: [
                  SettingsSwitchTile(
                    icon: Icons.vibration_rounded,
                    title: 'Haptic feedback',
                    subtitle: 'Small vibrations for taps and quest actions',
                    value: hapticFeedback,
                    onChanged: (value) => setState(() => hapticFeedback = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.photo_library_rounded,
                    title: 'Save uploaded photos',
                    subtitle: 'Keep a local copy after posting a quest',
                    value: saveUploadedPhotos,
                    onChanged: (value) => setState(() => saveUploadedPhotos = value),
                  ),
                  SettingsTile(
                    icon: Icons.palette_rounded,
                    title: 'Appearance',
                    subtitle: 'Dark mode, accent color and app icon',
                    trailingText: 'Dark',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: 'Choose your preferred app language',
                    trailingText: 'English',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: 'SUPPORT',
                children: [
                  SettingsTile(
                    icon: Icons.help_rounded,
                    title: 'Help center',
                    subtitle: 'Get support and read common answers',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.bug_report_rounded,
                    title: 'Report a problem',
                    subtitle: 'Tell us when something does not work',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.info_rounded,
                    title: 'About SideQuest',
                    subtitle: 'Version, credits and legal information',
                    trailingText: 'v1.0.0',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const DangerZoneCard(),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  'SideQuest • Keep exploring',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.32),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
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
