import 'package:flutter/material.dart';

import '../models/group_challenge.dart';

class ChallengeCard extends StatelessWidget {
  final GroupChallenge challenge;
  final VoidCallback onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF111419),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF20262E),
          ),
        ),
        child: Row(
          children: [
            _buildImage(),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1C222A),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        challenge.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.landscape_rounded,
            color: Color(0xFF00D7E8),
            size: 32,
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          challenge.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Text(
              '${challenge.members} Members',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${challenge.quests} Quests',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          challenge.category,
          style: const TextStyle(
            color: Color(0xFF00D7E8),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFF7668),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              'Start Group Challenge',
              style: TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}