import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ProfileStat(number: '248', label: 'Following'),
            const SizedBox(width: 28),

            Container(
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
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/Max.jpg'),
              ),
            ),

            const SizedBox(width: 28),
            _ProfileStat(number: '1.2K', label: 'Followers'),
          ],
        ),

        const SizedBox(height: 16),

        const Text(
          'Franz Hermann',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Side quests, chaos & tiny wins ✨\nPosting proof before I overthink it 📸\nCurrently collecting brave little moments 🚀',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFC8CDD5),
            fontSize: 13,
            height: 1.45,
          ),
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