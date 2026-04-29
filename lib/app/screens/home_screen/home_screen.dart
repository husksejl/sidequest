import 'package:flutter/material.dart';
import '../../shared/custom_bottom_nav.dart';
import 'models/sidequest_post.dart';
import 'widgets/header_section.dart';
import 'widgets/streak_status_section.dart';
import 'widgets/stories_section.dart';
import 'widgets/today_sidequest_card.dart';
import 'widgets/sidequest_header.dart';
import 'widgets/sidequest_post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color bgColor = Color(0xFF050608);

  static const List<SideQuestPost> posts = [
    SideQuestPost(
      userName: 'Alex Rivera',
      timeAgo: '20m ago',
      location: 'Rooftop Garden',
      title: 'URBAN OASIS',
      imageEmoji: '🌿',
      imageLabelTop: 'Y O U R S',
      imageLabelBottom: 'SAFE  •  SOFT  •  WILD',
      caption:
      'Found this gem on 5th Ave! Who knew a library roof could look like a jungle?',
      likes: 124,
      comments: 18,
      completedVotes: 21,
      notCompletedVotes: 3,
    ),
    SideQuestPost(
      userName: 'Sarah Kim',
      timeAgo: '42m ago',
      location: 'Old Town',
      title: 'SMILE HUNT',
      imageEmoji: '📸',
      imageLabelTop: 'M O M E N T',
      imageLabelBottom: 'LIGHT  •  JOY  •  CITY',
      caption:
      'Today’s SideQuest actually worked. Random little things made me smile all day.',
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
      bottomNavigationBar: const CustomBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const SizedBox(height: 18),
              const StreakStatusSection(),
              const SizedBox(height: 18),
              const StoriesSection(),
              const SizedBox(height: 18),
              const TodaySideQuestCard(),
              const SizedBox(height: 20),
              const SideQuestHeader(),
              const SizedBox(height: 14),
              for (final post in posts) ...[
                SideQuestPostCard(post: post),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}