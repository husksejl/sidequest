import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileLevelBar extends StatelessWidget {
  const ProfileLevelBar({super.key});

  static const int xpPerLevel = 250;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();

        final totalXp = data?['xp'] ?? 0;

        final level = totalXp ~/ xpPerLevel;
        final currentLevelXp = totalXp % xpPerLevel;
        final xpUntilNextLevel = xpPerLevel - currentLevelXp;
        final progress = currentLevelXp / xpPerLevel;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0B0E12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'LEVEL $level',
                    style: const TextStyle(
                      color: Color(0xFF00B2AA),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$currentLevelXp / $xpPerLevel XP',
                    style: const TextStyle(
                      color: Color(0xFF8A8F98),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Stack(
                  children: [
                    Container(
                      height: 9,
                      color: const Color(0xFF1A1A1A),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 9,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFEB5D4F),
                              Color(0xFF00B2AA),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$xpUntilNextLevel XP until Level ${level + 1}',
                style: const TextStyle(
                  color: Color(0xFFC8CDD5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}