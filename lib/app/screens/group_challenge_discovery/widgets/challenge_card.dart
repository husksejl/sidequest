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
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            _buildImage(context),
            const SizedBox(width: 12),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        challenge.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.landscape_rounded,
            color: Color(0xFF00D7E8),
            size: 32,
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          challenge.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Text(
              '${challenge.members} Members',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.24),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${challenge.quests} Quests',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          challenge.category,
          style: TextStyle(
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
          child: Center(
            child: Text(
              'Start Group Challenge',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
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