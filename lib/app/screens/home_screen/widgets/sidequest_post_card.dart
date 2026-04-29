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
                    colors: [Color(0xFFFF9B8F), Color(0xFF18D7FF)],
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

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1C2B1F),
                  Color(0xFF0E1813),
                  Color(0xFF16231E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    color: Color(0xFFE8E1D6),
                    fontSize: 20,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  height: 190,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF334D38),
                        Color(0xFF1D2D23),
                        Color(0xFF0F1712),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      post.imageEmoji,
                      style: const TextStyle(fontSize: 58),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  post.imageLabelTop,
                  style: const TextStyle(
                    color: Color(0xFFE8E1D6),
                    fontSize: 10,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.imageLabelBottom,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFCFD3CD),
                    fontSize: 10,
                    letterSpacing: 2.8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              PostStat(
                icon: Icons.favorite,
                value: '${post.likes}',
                iconColor: const Color(0xFFFF8D84),
              ),
              const SizedBox(width: 8),
              PostStat(
                icon: Icons.mode_comment_rounded,
                value: '${post.comments}',
                iconColor: const Color(0xFF18D7FF),
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
                        color: const Color(0xFF18D7FF),
                        icon: Icons.check_circle_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: VoteButton(
                        label: 'Not yet',
                        count: post.notCompletedVotes,
                        color: const Color(0xFFFF8D84),
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