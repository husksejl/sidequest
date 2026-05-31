import 'package:flutter/material.dart';

class OtherProfileHeader extends StatelessWidget {
  final int level;
  final int followingCount;
  final int followersCount;
  final String? profileImageUrl;
  final VoidCallback onFollowingTap;
  final VoidCallback onFollowersTap;

  const OtherProfileHeader({
    super.key,
    required this.level,
    required this.followingCount,
    required this.followersCount,
    required this.profileImageUrl,
    required this.onFollowingTap,
    required this.onFollowersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'LEVEL $level',
          style: TextStyle(
            color: Color(0xFF00B2AA),
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onFollowingTap,
              child: _OtherProfileStat(
                number: '$followingCount',
                label: 'Following',
              ),
            ),
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
              child: CircleAvatar(
                backgroundColor: const Color(0xFF111317),
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                  size: 48,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 28),
            GestureDetector(
              onTap: onFollowersTap,
              child: _OtherProfileStat(
                number: '$followersCount',
                label: 'Followers',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OtherProfileStat extends StatelessWidget {
  final String number;
  final String label;

  const _OtherProfileStat({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
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