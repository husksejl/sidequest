import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../login/login_page.dart';
import '../settings/widgets/danger_zone_card.dart';
import '../own_profile/widgets/edit_profile.dart';
import 'widgets/settings_profile_card.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_switch_tile.dart';
import 'widgets/settings_tile.dart';
import '../../shared/widgets/top_bar.dart';
import '../../shared/services/theme_service.dart';
import '../../shared/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings';
  static const Color bgColor = Color(0xFF050608);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateSetting(String key, bool value) async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      return;
    }

    await _firestore.collection('users').doc(uid).set({
      'settings': {
        key: value,
      },
    }, SetOptions(merge: true));
  }

  Future<void> _updateAppearanceMode(ThemeMode mode) async {
    ThemeService.setThemeMode(mode);

    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      return;
    }

    await _firestore.collection('users').doc(uid).set({
      'settings': {
        'appearanceMode': ThemeService.modeToString(mode),
      },
    }, SetOptions(merge: true));
  }

  void _openEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const EditProfileBottomSheet();
      },
    );
  }

  void _showAboutDialog(AppLocalizations l10n) {
    showAboutDialog(
      context: context,
      applicationName: 'SideQuest',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.explore_rounded,
        color: Color(0xFF18D7FF),
      ),
      children: const [
        Text(
          'SideQuest gives you small daily challenges and lets you share your solutions with others.',
        ),
      ],
    );
  }

  void _showAppearanceDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeService.themeMode,
          builder: (context, selectedMode, _) {
            return AlertDialog(
              backgroundColor: dialogContext.appCardColor,
              title: Text(
                'Appearance',
                style: TextStyle(color: dialogContext.appTextColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: selectedMode,
                    title: Text(
                      'System',
                      style: TextStyle(color: dialogContext.appTextColor),
                    ),
                    subtitle: Text(
                      'Follow your phone theme automatically.',
                      style: TextStyle(color: dialogContext.appMutedTextColor),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      _updateAppearanceMode(value);
                      Navigator.pop(dialogContext);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: selectedMode,
                    title: Text(
                      'Light',
                      style: TextStyle(color: dialogContext.appTextColor),
                    ),
                    subtitle: Text(
                      'Always use light mode.',
                      style: TextStyle(color: dialogContext.appMutedTextColor),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      _updateAppearanceMode(value);
                      Navigator.pop(dialogContext);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: selectedMode,
                    title: Text(
                      'Dark',
                      style: TextStyle(color: dialogContext.appTextColor),
                    ),
                    subtitle: Text(
                      'Always use dark mode.',
                      style: TextStyle(color: dialogContext.appMutedTextColor),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      _updateAppearanceMode(value);
                      Navigator.pop(dialogContext);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFaqDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: dialogContext.appCardColor,
          title: Text(
            'Help & FAQ',
            style: TextStyle(color: dialogContext.appTextColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                _DialogQuestion(
                  question: 'What is a SideQuest?',
                  answer:
                  'A SideQuest is a small daily challenge that gives you something fun or creative to do.',
                ),
                _DialogQuestion(
                  question: 'When does the daily SideQuest change?',
                  answer:
                  'The daily SideQuest changes at the start of a new day.',
                ),
                _DialogQuestion(
                  question: 'Can I edit my profile?',
                  answer:
                  'Yes. Open Settings, tap Edit Profile and update your visible profile information.',
                ),
                _DialogQuestion(
                  question: 'How does Appearance work?',
                  answer:
                  'You can choose System, Light or Dark. System follows your phone theme automatically.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBugReportDialog() async {
    final rootContext = context;
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSending = false;

    await showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> submitReport() async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              final user = _auth.currentUser;

              if (user == null) {
                Navigator.of(dialogContext).pop();
                Navigator.pushNamed(rootContext, LoginScreen.routeName);
                return;
              }

              setDialogState(() {
                isSending = true;
              });

              try {
                await _firestore.collection('bug_reports').add({
                  'userId': user.uid,
                  'email': user.email ?? '',
                  'title': titleController.text.trim(),
                  'details': detailsController.text.trim(),
                  'createdAt': Timestamp.now(),
                  'status': 'open',
                });

                if (!mounted) return;

                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(rootContext).showSnackBar(
                  const SnackBar(
                    content: Text('Bug report saved. Thank you!'),
                  ),
                );
              } catch (_) {
                if (!mounted) return;

                setDialogState(() {
                  isSending = false;
                });

                ScaffoldMessenger.of(rootContext).showSnackBar(
                  const SnackBar(
                    content: Text('Could not save the bug report.'),
                  ),
                );
              }
            }

            return AlertDialog(
              backgroundColor: dialogContext.appCardColor,
              title: Text(
                'Report a Bug',
                style: TextStyle(color: dialogContext.appTextColor),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        enabled: !isSending,
                        maxLength: 60,
                        decoration: const InputDecoration(
                          labelText: 'Short title',
                          hintText: 'Example: Chat input does not send',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: detailsController,
                        enabled: !isSending,
                        minLines: 4,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'What happened?',
                          hintText:
                          'Describe what you clicked and what went wrong.',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please describe the bug.';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSending
                      ? null
                      : () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: isSending ? null : submitReport,
                  child: isSending
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Send'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    detailsController.dispose();
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: dialogContext.appCardColor,
          title: Text(
            'Privacy & Data Protection',
            style: TextStyle(color: dialogContext.appTextColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                _DialogQuestion(
                  question: 'Account data',
                  answer:
                  'SideQuest uses your account information so you can log in and keep your profile connected to your activity.',
                ),
                _DialogQuestion(
                  question: 'Profile data',
                  answer:
                  'Your visible profile information can be changed through Edit Profile.',
                ),
                _DialogQuestion(
                  question: 'Settings data',
                  answer:
                  'Basic app settings like reminders and appearance are saved so your app behaves the way you selected.',
                ),
                _DialogQuestion(
                  question: 'Bug reports',
                  answer:
                  'If you send a bug report, the report text and your account email may be saved so the team can understand the issue.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _displayNameFromData(Map<String, dynamic>? data, User? user) {
    final fullName = data?['fullName']?.toString().trim() ?? '';
    final firstName = data?['firstName']?.toString().trim() ?? '';
    final username = data?['username']?.toString().trim() ?? '';
    final firebaseName = user?.displayName?.trim() ?? '';
    final email = user?.email?.trim() ?? '';

    if (fullName.isNotEmpty) return fullName;
    if (firstName.isNotEmpty) return firstName;
    if (username.isNotEmpty) return username;
    if (firebaseName.isNotEmpty) return firebaseName;
    if (email.isNotEmpty) return email.split('@').first;

    return 'SideQuest User';
  }

  String _handleFromData(Map<String, dynamic>? data, User? user) {
    final username = data?['username']?.toString().trim() ?? '';
    final userEmail = user?.email?.trim() ?? '';
    final dataEmail = data?['email']?.toString().trim() ?? '';
    final email = userEmail.isNotEmpty ? userEmail : dataEmail;

    if (username.isNotEmpty) return '@$username';
    if (email.isNotEmpty) return email;

    return '@sidequest';
  }

  bool _settingValue(
      Map<String, dynamic>? data,
      String key,
      bool fallback,
      ) {
    final settings = data?['settings'];

    if (settings is Map<String, dynamic>) {
      final value = settings[key];

      if (value is bool) {
        return value;
      }
    }

    return fallback;
  }

  String _appearanceSubtitle() {
    final mode = ThemeService.currentMode;
    final label = ThemeService.labelForMode(mode);

    if (mode == ThemeMode.system) {
      return 'Current: $label - follows your phone theme.';
    }

    return 'Current: $label mode.';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = _auth.currentUser;
    final uid = user?.uid;

    return Scaffold(
      backgroundColor: context.appBackground,
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

              if (uid == null)
                SettingsProfileCard(
                  userName: 'SideQuest User',
                  userHandle: l10n.pleaseLogIn,
                  streak: 0,
                  level: l10n.rookieAdventurer,
                )
              else
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _firestore.collection('users').doc(uid).snapshots(),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.data();

                    return SettingsProfileCard(
                      userName: _displayNameFromData(data, user),
                      userHandle: _handleFromData(data, user),
                      streak: data?['streak'] ?? 0,
                      level: l10n.rookieAdventurer,
                    );
                  },
                ),

              const SizedBox(height: 18),

              SettingsSection(
                title: l10n.account,
                children: [
                  SettingsTile(
                    icon: Icons.person_rounded,
                    title: l10n.editProfile,
                    subtitle: l10n.editProfileSubtitle,
                    onTap: uid == null
                        ? () => Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                    )
                        : _openEditProfile,
                  ),
                  SettingsTile(
                    icon: Icons.mail_rounded,
                    title: l10n.emailAndLogin,
                    subtitle: user?.email ?? l10n.emailAndLoginSubtitle,
                    onTap: () => Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              if (uid == null)
                SettingsSection(
                  title: l10n.appExperience,
                  children: [
                    ValueListenableBuilder<ThemeMode>(
                      valueListenable: ThemeService.themeMode,
                      builder: (context, mode, _) {
                        return SettingsTile(
                          icon: Icons.brightness_auto_rounded,
                          title: 'Appearance',
                          subtitle: _appearanceSubtitle(),
                          onTap: _showAppearanceDialog,
                        );
                      },
                    ),
                  ],
                )
              else
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _firestore.collection('users').doc(uid).snapshots(),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.data();

                    final dailyQuestReminder = _settingValue(
                      data,
                      'dailyQuestReminder',
                      true,
                    );

                    final hapticFeedback = _settingValue(
                      data,
                      'hapticFeedback',
                      true,
                    );

                    final saveUploadedPhotos = _settingValue(
                      data,
                      'saveUploadedPhotos',
                      false,
                    );

                    return SettingsSection(
                      title: l10n.appExperience,
                      children: [
                        ValueListenableBuilder<ThemeMode>(
                          valueListenable: ThemeService.themeMode,
                          builder: (context, mode, _) {
                            return SettingsTile(
                              icon: Icons.brightness_auto_rounded,
                              title: 'Appearance',
                              subtitle: _appearanceSubtitle(),
                              onTap: _showAppearanceDialog,
                            );
                          },
                        ),

                        SettingsSwitchTile(
                          icon: Icons.today_rounded,
                          title: l10n.dailySideQuestReminder,
                          subtitle: l10n.dailySideQuestReminderSubtitle,
                          value: dailyQuestReminder,
                          onChanged: (value) {
                            _updateSetting('dailyQuestReminder', value);
                          },
                        ),

                        SettingsSwitchTile(
                          icon: Icons.vibration_rounded,
                          title: l10n.hapticFeedback,
                          subtitle: l10n.hapticFeedbackSubtitle,
                          value: hapticFeedback,
                          onChanged: (value) {
                            _updateSetting('hapticFeedback', value);
                          },
                        ),

                        SettingsSwitchTile(
                          icon: Icons.photo_library_rounded,
                          title: l10n.saveUploadedPhotos,
                          subtitle: l10n.saveUploadedPhotosSubtitle,
                          value: saveUploadedPhotos,
                          onChanged: (value) {
                            _updateSetting('saveUploadedPhotos', value);
                          },
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 16),

              SettingsSection(
                title: 'Help & Info',
                children: [
                  SettingsTile(
                    icon: Icons.help_rounded,
                    title: 'Help / FAQ',
                    subtitle: 'Read quick answers about using SideQuest.',
                    onTap: _showFaqDialog,
                  ),
                  SettingsTile(
                    icon: Icons.bug_report_rounded,
                    title: 'Report a Bug',
                    subtitle: 'Send a short report if something is broken.',
                    onTap: _showBugReportDialog,
                  ),
                  SettingsTile(
                    icon: Icons.privacy_tip_rounded,
                    title: 'Privacy & Data Protection',
                    subtitle: 'See what data SideQuest stores and why.',
                    onTap: _showPrivacyDialog,
                  ),
                  SettingsTile(
                    icon: Icons.info_rounded,
                    title: l10n.aboutSideQuest,
                    subtitle: l10n.aboutSideQuestSubtitle,
                    trailingText: 'v1.0.0',
                    onTap: () => _showAboutDialog(l10n),
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
                    color: context.appMutedTextColor.withOpacity(0.7),
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

class _DialogQuestion extends StatelessWidget {
  final String question;
  final String answer;

  const _DialogQuestion({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              color: context.appTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              color: context.appMutedTextColor,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}