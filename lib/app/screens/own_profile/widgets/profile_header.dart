import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../other_profile/other_profile_page.dart';
import '../own_profile_page.dart';
import '../../../shared/widgets/follow_list_sheet.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!doc.exists) return;

    setState(() {
      profileImageUrl = doc.data()?['profileImageUrl'];
    });
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: source,
      imageQuality: 75,
    );

    if (image == null) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    final file = File(image.path);

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('$uid.jpg');

    await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final downloadUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
      'profileImageUrl': downloadUrl,
    }, SetOptions(merge: true));

    setState(() {
      profileImageUrl = downloadUrl;
    });
  }

  void showImageOptions() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF101216),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ProfileImageOption(
                icon: Icons.camera_alt_rounded,
                label: l10n.camera,
                onTap: () {
                  Navigator.pop(context);
                  pickAndUploadImage(ImageSource.camera);
                },
              ),

              _ProfileImageOption(
                icon: Icons.photo_library_rounded,
                label: l10n.gallery,
                onTap: () {
                  Navigator.pop(context);
                  pickAndUploadImage(ImageSource.gallery);
                },
              ),

              _ProfileImageOption(
                icon: Icons.delete_outline_rounded,
                label: l10n.remove,
                onTap: () async {
                  Navigator.pop(context);

                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid == null) return;

                  try {
                    await FirebaseStorage.instance
                        .ref()
                        .child('profile_pictures')
                        .child('$uid.jpg')
                        .delete();
                  } catch (_) {
                    // falls kein Bild existiert, ignorieren
                  }

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .set({
                    'profileImageUrl': null,
                  }, SetOptions(merge: true));

                  setState(() {
                    profileImageUrl = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showFollowList({
    required String title,
    required List<String> userIds,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF101216),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => FollowListSheet(
        title: title,
        userIds: userIds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();

            final followers = List<String>.from(data?['followers'] ?? []);
            final following = List<String>.from(data?['following'] ?? []);

            final followersCount = data?['followersCount'] ?? followers.length;
            final followingCount = data?['followingCount'] ?? following.length;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showFollowList(
                      title: l10n.followingProfile,
                      userIds: following,
                    );
                  },
                  child: _ProfileStat(
                    number: '$followingCount',
                    label: l10n.followingProfile,
                  ),
                ),
                const SizedBox(width: 28),

                GestureDetector(
                  onTap: showImageOptions,
                  child: Container(
                    width: 108,
                    height: 108,
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFEB5D4F),
                          Color(0xFF00B2AA),
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF111317),
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : null,
                      child: profileImageUrl == null
                          ? const Icon(
                        Icons.person_rounded,
                        color: Colors.white54,
                        size: 48,
                      )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(width: 28),
                GestureDetector(
                  onTap: () {
                    showFollowList(
                      title: l10n.followers,
                      userIds: followers,
                    );
                  },
                  child: _ProfileStat(
                    number: '$followersCount',
                    label: l10n.followers,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                Text(
                  data['username'] ?? l10n.unknownUser,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  (data['firstName'] ?? '')
                      .toString()
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            );
          },
        ),

        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            final bio = data?['bio']?.toString().trim();
            final location = data?['location']?.toString();
            final locationLat = data?['locationLat']?.toString();
            final locationLon = data?['locationLon']?.toString();
            final website = data?['website']?.toString();

            if (bio == null || bio.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                const SizedBox(height: 8),

                Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFC8CDD5),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),

                if (location != null && location.isNotEmpty) ...[
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () async {
                      final uri = locationLat != null &&
                          locationLon != null
                          ? Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=$locationLat,$locationLon',
                      )
                          : Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}',
                      );

                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF00B2AA),
                          size: 15,
                        ),

                        const SizedBox(width: 4),

                        Flexible(
                          child: Text(
                            location,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (website != null && website.isNotEmpty) ...[
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () async {
                      String url = website.trim();

                      if (!url.startsWith('http://') && !url.startsWith('https://')) {
                        url = 'https://$url';
                      }

                      final uri = Uri.parse(url);

                      final opened = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );

                      if (!opened && context.mounted) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.platformDefault,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.link_rounded,
                          color: Color(0xFFEB5D4F),
                          size: 15,
                        ),

                        const SizedBox(width: 4),

                        Flexible(
                          child: Text(
                            website,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String number;
  final String label;

  const _ProfileStat({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF8A8F98),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _ProfileImageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileImageOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF15181D),
              border: Border.all(
                color: const Color(0xFF18D7FF).withOpacity(0.4),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF18D7FF),
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}