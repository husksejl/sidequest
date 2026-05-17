import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
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
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: const Center(
                child: Text(
                  'EDIT PROFILE',
                  style: TextStyle(
                    color: Colors.white,
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

            final username = data['username'] ?? 'Unknown';
            final firstName = data['firstName'] ?? '';
            final bio = data['bio'] ?? '';
            final location = data['location'] ?? '';
            final website = data['website'] ?? '';

            final text = '''
Check out my SideQuest profile!

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
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: const Icon(
              Icons.ios_share_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}