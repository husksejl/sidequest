import 'package:flutter/material.dart';

import '../../shared/custom_bottom_nav.dart';

import 'models/group_challenge.dart';
import 'widgets/challenge_card.dart';
import 'widgets/challenge_category_chip.dart';
import 'widgets/challenge_detail_page.dart';

class GroupChallengeDiscoveryPage extends StatefulWidget {
  const GroupChallengeDiscoveryPage({super.key});

  @override
  State<GroupChallengeDiscoveryPage> createState() =>
      _GroupChallengeDiscoveryPageState();
}

class _GroupChallengeDiscoveryPageState
    extends State<GroupChallengeDiscoveryPage> {
  String selectedCategory = 'All Groups';

  final List<String> categories = [
    'All Groups',
    'Active Quests',
    'Local',
    'Friends',
  ];

  final List<GroupChallenge> challenges = const [
    GroupChallenge(
      id: '1',
      title: 'Creative Nomads',
      subtitle: 'Turn everyday places into tiny art quests.',
      description:
      'A group challenge for people who love exploring the city creatively. Find small details, strange textures, hidden corners and turn them into visual stories.',
      imagePath: 'assets/images/creative_nomads.jpg',
      members: 42,
      quests: 8,
      category: 'Arts & Design',
      level: 'Intermediate',
      reward: '450 XP',
      time: '2h 30m',
      questIdeas: [
        'Find a wall texture that looks like another planet.',
        'Take a photo of an object that feels out of place.',
        'Create a tiny story from three random street signs.',
      ],
    ),
    GroupChallenge(
      id: '2',
      title: 'Urban Explorers',
      subtitle: 'Rediscover your surroundings.',
      description:
      'Most of us live in a state of autopilot. This challenge helps you slow down, notice your city and collect tiny discoveries with your group.',
      imagePath: 'assets/images/urban_explorers.jpg',
      members: 128,
      quests: 7,
      category: 'Photography',
      level: 'Intermediate',
      reward: '450 XP',
      time: '2h 30m',
      questIdeas: [
        'The Three Lefts Rule: take three left turns and photograph what you find.',
        'The Ghost Menu: find a café, menu or sign that looks forgotten.',
        'Concrete Textures: capture close-ups of cracked walls, floors or stairs.',
        'Scenery Hunt: find a peaceful view hidden in the city.',
      ],
    ),
    GroupChallenge(
      id: '3',
      title: 'Midnight Coders',
      subtitle: 'Small coding tasks after dark.',
      description:
      'A cozy coding challenge group for night owls. Solve small creative programming prompts and share your results with others.',
      imagePath: 'assets/images/midnight_coders.jpg',
      members: 87,
      quests: 5,
      category: 'Tech',
      level: 'Easy',
      reward: '300 XP',
      time: '1h 15m',
      questIdeas: [
        'Build a random color generator.',
        'Create a tiny todo list UI.',
        'Make a button that changes its mood.',
      ],
    ),
  ];

  List<GroupChallenge> get filteredChallenges {
    if (selectedCategory == 'All Groups') {
      return challenges;
    }

    if (selectedCategory == 'Active Quests') {
      return challenges.where((challenge) => challenge.quests > 5).toList();
    }

    if (selectedCategory == 'Local') {
      return challenges
          .where((challenge) => challenge.title.contains('Urban'))
          .toList();
    }

    if (selectedCategory == 'Friends') {
      return challenges
          .where((challenge) => challenge.title.contains('Creative'))
          .toList();
    }

    return challenges;
  }

  void openChallengeDetail(GroupChallenge challenge) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeDetailPage(challenge: challenge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF7668),
        foregroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 22),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildCategoryList(),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredChallenges.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final challenge = filteredChallenges[index];

                    return ChallengeCard(
                      challenge: challenge,
                      onTap: () => openChallengeDetail(challenge),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFF1C1F24),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF15181D),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Text(
                'Your Groups',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 6),
              Icon(
                Icons.notifications_none,
                color: Colors.white54,
                size: 15,
              ),
            ],
          ),
        ),
        const Spacer(),
        const Text(
          'SideQuest',
          style: TextStyle(
            color: Color(0xFFFF7668),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF101317),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF1E252C),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.search,
            color: Color(0xFF00D7E8),
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Find your next group quest',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];

          return ChallengeCategoryChip(
            title: category,
            isSelected: selectedCategory == category,
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }
}