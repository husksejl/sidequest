import 'package:flutter/material.dart';

class ProfileLevelBar extends StatelessWidget {
  const ProfileLevelBar({super.key});

  @override
  Widget build(BuildContext context) {
    const double progress = 0.72;

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
          const Row(
            children: [
              Text(
                'LEVEL 7',
                style: TextStyle(
                  color: Color(0xFF00B2AA),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              Spacer(),
              Text(
                '200 / 250 XP',
                style: TextStyle(
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
          const Text(
            '50 XP until Level 8',
            style: TextStyle(
              color: Color(0xFFC8CDD5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}