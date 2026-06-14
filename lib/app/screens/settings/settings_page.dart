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

  Future<void> _submitBugReport({
    required String title,
    required String description,
  }) async {
    final user = _auth.currentUser;
    final uid = user?.uid;

    if (uid == null) {
      throw Exception('You need to be logged in to send a bug report.');
    }

    await _firestore.collection('bug_reports').add({
      'userId': uid,
      'email': user?.email ?? '',
      'title': title,
      'description': description,
      'createdAt': Timestamp.now(),
      'status': 'open',
    });
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

  void _showFaqDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Help / FAQ'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is SideQuest?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'SideQuest gives you small daily challenges that you can complete and share with others.',
                ),
                SizedBox(height: 16),

                Text(
                  'How do daily SideQuests work?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'A new SideQuest appears every day. After completing it, you can upload your solution.',
                ),
                SizedBox(height: 16),

                Text(
                  'Can I change my profile?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Yes. Use the Edit Profile option in the account section.',
                ),
                SizedBox(height: 16),

                Text(
                  'Why are some features still basic?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Some parts are currently simplified because SideQuest is still a student project prototype.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy & Data Protection'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SideQuest only stores the data needed for the app prototype to work.',
                ),
                SizedBox(height: 16),

                Text(
                  'Stored account data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Your profile information, email address, settings and uploaded SideQuest content may be stored in Firebase.',
                ),
                SizedBox(height: 16),

                Text(
                  'Bug reports',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'If you submit a bug report, the report text and your account email may be saved so the team can understand the issue.',
                ),
                SizedBox(height: 16),

                Text(
                  'Prototype note',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'This privacy section is a simplified information page for the university prototype and not a full legal privacy policy.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
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

  void _openBugReportDialog() {
    final rootContext = context;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: rootContext,
      builder: (dialogContext) {
        bool isSending = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> sendReport() async {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();

              if (title.isEmpty || description.isEmpty) {
                ScaffoldMessenger.of(rootContext).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill out both fields.'),
                  ),
                );
                return;
              }

              setDialogState(() {
                isSending = true;
              });

              try {
                await _submitBugReport(
                  title: title,
                  description: description,
                );

                if (!mounted) return;

                Navigator.of(dialogContext).pop();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!rootContext.mounted) return;

                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    const SnackBar(
                      content: Text('Bug report sent. Thank you!'),
                    ),
                  );
                });
              } catch (error) {
                if (!mounted) return;

                setDialogState(() {
                  isSending = false;
                });

                ScaffoldMessenger.of(rootContext).showSnackBar(
                  SnackBar(
                    content: Text('Could not send bug report: $error'),
                  ),
                );
              }
            }

            return AlertDialog(
              title: const Text('Report a Bug'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Bug title',
                        hintText: 'Example: App crashes on upload',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'What happened? What did you try to do?',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
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
                  onPressed: isSending ? null : sendReport,
                  child: isSending
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Send'),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      titleController.dispose();
      descriptionController.dispose();
    });
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

  void _setLightMode(bool value) {
    ThemeService.setLightMode(value);
    _updateSetting('lightMode', value);
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
                      builder: (context, themeMode, _) {
                        final isLightMode = themeMode == ThemeMode.light;

                        return SettingsSwitchTile(
                          icon: Icons.light_mode_rounded,
                          title: 'Light Mode',
                          subtitle: isLightMode
                              ? 'Die App wird aktuell hell dargestellt.'
                              : 'Aktivieren, um die App hell darzustellen.',
                          value: isLightMode,
                          onChanged: _setLightMode,
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
                          builder: (context, themeMode, _) {
                            final isLightMode = themeMode == ThemeMode.light;

                            return SettingsSwitchTile(
                              icon: Icons.light_mode_rounded,
                              title: 'Light Mode',
                              subtitle: isLightMode
                                  ? 'Die App wird aktuell hell dargestellt.'
                                  : 'Aktivieren, um die App hell darzustellen.',
                              value: isLightMode,
                              onChanged: _setLightMode,
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
                    subtitle: 'Read quick answers about SideQuest.',
                    onTap: _showFaqDialog,
                  ),
                  SettingsTile(
                    icon: Icons.bug_report_rounded,
                    title: 'Report a Bug',
                    subtitle: 'Tell us if something does not work.',
                    onTap: _openBugReportDialog,
                  ),
                  SettingsTile(
                    icon: Icons.privacy_tip_rounded,
                    title: 'Privacy & Data Protection',
                    subtitle: 'Read how your data is handled.',
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