import 'package:flutter/material.dart';

import '../models/sidequest_post.dart';
import 'post_stat.dart';
import 'vote_button.dart';

class SideQuestPostCard extends StatelessWidget {
  final SideQuestPost post;

  const SideQuestPostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0E12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFEB5D4F), Color(0xFF00B2AA)],
                  ),
                ),
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF1B2026),
                  child: Icon(Icons.person, color: Colors.white70),
                ),
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
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${post.timeAgo}  •  ${post.location}',
                      style: const TextStyle(
                        color: Color(0xFF8A8F98),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              post.userName == 'Charles L.'
                  ? 'assets/images/Charles.jpg'
                  : 'assets/images/Max.jpg',
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              PostStat(
                icon: Icons.favorite,
                value: '${post.likes}',
                iconColor: const Color(0xFFEB5D4F),
              ),
              const SizedBox(width: 8),
              PostStat(
                icon: Icons.mode_comment_rounded,
                value: '${post.comments}',
                iconColor: const Color(0xFF00B2AA),
              ),
              const Spacer(),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_rounded,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.caption,
            style: const TextStyle(
              color: Color(0xFFC8CDD5),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Did they complete the SideQuest?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: VoteButton(
                        label: 'Completed',
                        count: post.completedVotes,
                        color: const Color(0xFF00B2AA),
                        icon: Icons.check_circle_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: VoteButton(
                        label: 'Not yet',
                        count: post.notCompletedVotes,
                        color: const Color(0xFFEB5D4F),
                        icon: Icons.cancel_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
