import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../signup/signup_page.dart';
import '../login/login_page.dart';
import '../settings/widgets/danger_zone_card.dart';
import 'widgets/settings_profile_card.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_switch_tile.dart';
import 'widgets/settings_tile.dart';
import '../../shared/widgets/top_bar.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: SettingsScreen.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(
                showSettings: false,
                showBackButton: true,
              ),
              SettingsProfileCard(
                userName: 'Alex Explorer',
                userHandle: '@alexexplores',
                streak: 5,
                level: l10n.rookieAdventurer,
              ),
              const SizedBox(height: 18),
              SettingsSection(
                title: l10n.account,
                children: [
                  SettingsTile(
                    icon: Icons.person_rounded,
                    title: l10n.editProfile,
                    subtitle: l10n.editProfileSubtitle,
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.mail_rounded,
                    title: l10n.emailAndLogin,
                    subtitle: l10n.emailAndLoginSubtitle,
                    onTap: () => Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.person_add_alt_1_rounded,
                    title: l10n.createNewProfile,
                    subtitle: l10n.createNewProfileSubtitle,
                    accentColor: const Color(0xFF18D7FF),
                    onTap: () => Navigator.pushNamed(
                      context,
                      CreateAccountScreen.routeName,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.emoji_events_rounded,
                    title: l10n.questPreferences,
                    subtitle: l10n.questPreferencesSubtitle,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: l10n.notifications.toUpperCase(),
                children: [
                  SettingsSwitchTile(
                    icon: Icons.notifications_rounded,
                    title: l10n.pushNotifications,
                    subtitle: l10n.pushNotificationsSubtitle,
                    value: pushNotifications,
                    onChanged: (value) => setState(() => pushNotifications = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.today_rounded,
                    title: l10n.dailySideQuestReminder,
                    subtitle: l10n.dailySideQuestReminderSubtitle,
                    value: dailyQuestReminder,
                    onChanged: (value) => setState(() => dailyQuestReminder = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.local_fire_department_rounded,
                    title: l10n.streakWarning,
                    subtitle: l10n.streakWarningSubtitle,
                    value: streakWarning,
                    onChanged: (value) => setState(() => streakWarning = value),
                    accentColor: const Color(0xFFFF8D84),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: l10n.privacyAndSafety,
                children: [
                  SettingsSwitchTile(
                    icon: Icons.lock_rounded,
                    title: l10n.privateProfile,
                    subtitle: l10n.privateProfileSubtitle,
                    value: privateProfile,
                    onChanged: (value) => setState(() => privateProfile = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.group_add_rounded,
                    title: l10n.allowFriendRequests,
                    subtitle: l10n.allowFriendRequestsSubtitle,
                    value: allowFriendRequests,
                    onChanged: (value) => setState(() => allowFriendRequests = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.location_on_rounded,
                    title: l10n.locationHints,
                    subtitle: l10n.locationHintsSubtitle,
                    value: locationHints,
                    onChanged: (value) => setState(() => locationHints = value),
                    accentColor: const Color(0xFFFF8D84),
                  ),
                  SettingsTile(
                    icon: Icons.visibility_off_rounded,
                    title: l10n.blockedAccounts,
                    subtitle: l10n.blockedAccountsSubtitle,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: l10n.appExperience,
                children: [
                  SettingsSwitchTile(
                    icon: Icons.vibration_rounded,
                    title: l10n.hapticFeedback,
                    subtitle: l10n.hapticFeedbackSubtitle,
                    value: hapticFeedback,
                    onChanged: (value) => setState(() => hapticFeedback = value),
                  ),
                  SettingsSwitchTile(
                    icon: Icons.photo_library_rounded,
                    title: l10n.saveUploadedPhotos,
                    subtitle: l10n.saveUploadedPhotosSubtitle,
                    value: saveUploadedPhotos,
                    onChanged: (value) => setState(() => saveUploadedPhotos = value),
                  ),
                  SettingsTile(
                    icon: Icons.palette_rounded,
                    title: l10n.appearance,
                    subtitle: l10n.appearanceSubtitle,
                    trailingText: l10n.dark,
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.language_rounded,
                    title: l10n.language,
                    subtitle: l10n.languageSubtitle,
                    trailingText: l10n.english,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsSection(
                title: l10n.support,
                children: [
                  SettingsTile(
                    icon: Icons.help_rounded,
                    title: l10n.helpCenter,
                    subtitle: l10n.helpCenterSubtitle,
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.bug_report_rounded,
                    title: l10n.reportProblem,
                    subtitle: l10n.reportProblemSubtitle,
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.info_rounded,
                    title: l10n.aboutSideQuest,
                    subtitle: l10n.aboutSideQuestSubtitle,
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
                  l10n.keepExploring,
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
