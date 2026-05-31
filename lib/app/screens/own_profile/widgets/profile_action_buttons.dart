import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';
import 'edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const EditProfileBottomSheet(),
              );
            },
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06)),
              ),
              child: Center(
                child: Text(
                  l10n.editProfileCaps,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            final uid = FirebaseAuth.instance.currentUser?.uid;
            if (uid == null) return;

            final doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();

            final data = doc.data();
            if (data == null) return;

            final username = data['username'] ?? l10n.unknownUser;
            final firstName = data['firstName'] ?? '';
            final bio = data['bio'] ?? '';
            final location = data['location'] ?? '';
            final website = data['website'] ?? '';

            final text = '''
${l10n.checkOutMyProfile}

@$username
${firstName.toString().isNotEmpty ? firstName.toString().toUpperCase() : ''}

${bio.toString().isNotEmpty ? bio : ''}
${location.toString().isNotEmpty ? '📍 $location' : ''}
${website.toString().isNotEmpty ? '🔗 $website' : ''}
''';

            await Share.share(text.trim());
          },
          child: Container(
            width: 42,
            height: 38,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06)),
            ),
            child: Icon(
              Icons.ios_share_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}