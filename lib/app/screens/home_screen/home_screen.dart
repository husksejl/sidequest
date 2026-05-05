import 'package:flutter/material.dart';
import '../../shared/custom_bottom_nav.dart';
import 'models/sidequest_post.dart';
import 'widgets/header_section.dart';
import 'widgets/stories_section.dart';
import 'widgets/today_sidequest_card.dart';
import 'widgets/sidequest_post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color bgColor = Color(0xFF050608);

  static const List<SideQuestPost> posts = [
    SideQuestPost(
      userName: 'Max V.',
      timeAgo: '20m ago',
      location: 'Melbourne',
      title: 'URBAN OASIS',
      imageEmoji: '🌿',
      imageLabelTop: 'Y O U R S',
      imageLabelBottom: 'SAFE  •  SOFT  •  WILD',
      caption:
      'I put on a wig and suddenly have opinions #quirky',
      likes: 124,
      comments: 18,
      completedVotes: 21,
      notCompletedVotes: 3,
    ),
    SideQuestPost(
      userName: 'Charles L.',
      timeAgo: '42m ago',
      location: 'Monte Carlo',
      title: 'SMILE HUNT',
      imageEmoji: '📸',
      imageLabelTop: 'M O M E N T',
      imageLabelBottom: 'LIGHT  •  JOY  •  CITY',
      caption:
      'The mask told me to do it 🤪',
      likes: 89,
      comments: 11,
      completedVotes: 17,
      notCompletedVotes: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const SizedBox(height: 18),

              const StoriesSection(),
              const SizedBox(height: 18),

              const TodaySideQuestCard(),
              const SizedBox(height: 24),

              const SearchBarHome(),
              const SizedBox(height: 20),

              const Text(
                "Today's Missions",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              const MissionTabs(),
              const SizedBox(height: 18),

              for (final post in posts) ...[
                SideQuestPostCard(post: post),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white70),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.white70, size: 30),
        ],
      ),
    );
  }
}

class MissionTabs extends StatelessWidget {
  const MissionTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white),
              color: Color(0xFF1A1A1A),
            ),
            child: const Center(
              child: Text(
                'FOLLOWING',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 26),
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF1A1A1A)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Center(
              child: Text(
                'FOR YOU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
