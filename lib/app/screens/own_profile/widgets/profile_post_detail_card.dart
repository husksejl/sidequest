import 'package:flutter/material.dart';
import '../models/profile_post.dart';

class ProfilePostDetailCard extends StatelessWidget {
  final ProfilePost post;

  const ProfilePostDetailCard({
    super.key,
    required this.post,
  });

  Color get statusColor {
    switch (post.voteStatus) {
      case VoteStatus.completed:
        return const Color(0xFF00B2AA);
      case VoteStatus.failed:
        return const Color(0xFFEB5D4F);
      case VoteStatus.undecided:
        return const Color(0xFF8A8F98);
    }
  }

  String get statusText {
    if (post.votingOpen) return 'Voting open';
    switch (post.voteStatus) {
      case VoteStatus.completed:
        return 'Quest completed';
      case VoteStatus.failed:
        return 'Quest failed';
      case VoteStatus.undecided:
        return 'Vote undecided';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0E12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage('assets/images/Max.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${post.timeAgo} • ${post.location}',
                        style: const TextStyle(
                          color: Color(0xFF8A8F98),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  post.type == ProfilePostType.video
                      ? Icons.play_arrow_rounded
                      : post.type == ProfilePostType.audio
                      ? Icons.graphic_eq_rounded
                      : post.type == ProfilePostType.text
                      ? Icons.title_rounded
                      : Icons.image_rounded,
                  color: Colors.white54,
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                post.assetPath,
                height: 390,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                _SmallStat(
                  icon: Icons.favorite,
                  value: '${post.likes}',
                  color: const Color(0xFFEB5D4F),
                ),
                const SizedBox(width: 8),
                _SmallStat(
                  icon: Icons.chat_bubble_outline_rounded,
                  value: '${post.comments}',
                  color: const Color(0xFF00B2AA),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post.caption,
                style: const TextStyle(
                  color: Color(0xFFC8CDD5),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),

            if (post.votingOpen) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _VotePreviewButton(
                        label: 'Complete',
                        color: const Color(0xFF00B2AA),
                        icon: Icons.check_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _VotePreviewButton(
                        label: 'Fail',
                        color: const Color(0xFFEB5D4F),
                        icon: Icons.close_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _SmallStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _VotePreviewButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _VotePreviewButton({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}