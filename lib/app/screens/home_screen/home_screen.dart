import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/models/daily_sidequest.dart';
import '../../shared/services/daily_sidequest_service.dart';
import '../../shared/widgets/custom_bottom_nav.dart';
import '../../shared/widgets/top_bar.dart';
import '../create/models/create_quest.dart';
import '../create/photo_preview_page.dart';
import 'models/sidequest_post.dart';
import 'widgets/sidequest_post_card.dart';
import 'widgets/stories_section.dart';
import 'widgets/today_sidequest_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';
  static const Color bgColor = Color(0xFF050608);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DailySideQuestService _dailySideQuestService = DailySideQuestService();

  late Timer _dateTimer;
  late String _todayDate;

  static const List<SideQuestPost> posts = [
    SideQuestPost(
      userName: 'Max V.',
      timeAgo: '20m ago',
      location: 'Melbourne',
      title: 'URBAN OASIS',
      imageEmoji: '🌿',
      imageLabelTop: 'Y O U R S',
      imageLabelBottom: 'SAFE  •  SOFT  •  WILD',
      caption: 'I put on a wig and suddenly have opinions #quirky',
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
      caption: 'The mask told me to do it 🤪',
      likes: 89,
      comments: 11,
      completedVotes: 17,
      notCompletedVotes: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _todayDate = _formatDate(DateTime.now());

    _ensureTodaySideQuestExists();

    _dateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final newDate = _formatDate(DateTime.now());

      if (newDate != _todayDate) {
        setState(() {
          _todayDate = newDate;
        });

        _ensureTodaySideQuestExists();
      }
    });
  }

  @override
  void dispose() {
    _dateTimer.cancel();
    super.dispose();
  }

  Future<void> _ensureTodaySideQuestExists() async {
    await _dailySideQuestService.getOrCreateTodayDailySideQuest();

    if (!mounted) return;

    setState(() {});
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String _formatTimeUntilMidnight() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final remaining = nextMidnight.difference(now);

    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    final hours = twoDigits(remaining.inHours);
    final minutes = twoDigits(remaining.inMinutes.remainder(60));
    final seconds = twoDigits(remaining.inSeconds.remainder(60));

    return '$hours  :  $minutes  :  $seconds';
  }

  CreateQuest _toCreateQuest(DailySideQuest sideQuest) {
    return CreateQuest(
      id: sideQuest.id,
      title: sideQuest.title,
      description: sideQuest.description,
      expiresIn: _formatTimeUntilMidnight(),
      difficulty: sideQuest.difficulty,
      xp: sideQuest.xp,
      isGroupQuest: false,
      date: sideQuest.date,
    );
  }

  Future<void> _openCameraForDailySideQuest(DailySideQuest sideQuest) async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo == null || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPreviewPage(
          imagePath: photo.path,
          quest: _toCreateQuest(sideQuest),
        ),
      ),
    );
  }

  Widget _buildTodaySideQuest() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<DailySideQuest?>(
      stream: _dailySideQuestService.watchDailySideQuestByDate(_todayDate),
      builder: (context, sideQuestSnapshot) {
        if (sideQuestSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final sideQuest = sideQuestSnapshot.data;

        if (sideQuest == null) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<bool>(
          stream: _dailySideQuestService.watchIsDailySideQuestCompleted(
            userID: user.uid,
            sideQuestID: sideQuest.id,
            date: sideQuest.date,
          ),
          builder: (context, completedSnapshot) {
            final isCompleted = completedSnapshot.data ?? false;

            if (isCompleted) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                TodaySideQuestCard(
                  sideQuest: sideQuest,
                  onCameraTap: () {
                    _openCameraForDailySideQuest(sideQuest);
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFirestoreFeed() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(
                color: Color(0xFFEB5D4F),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
            'No posts yet.',
            style: TextStyle(color: Colors.white54),
          );
        }

        final docs = snapshot.data!.docs;

        return Column(
          children: docs.map((doc) {
            final data = doc.data();

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SideQuestPostCard(
                post: SideQuestPost(
                  userName: data['username'] ?? 'Unknown',
                  timeAgo: 'now',
                  location: 'SideQuest',
                  userId: data['userId'],
                  title: data['questTitle'] ?? '',
                  imageEmoji: '',
                  imageLabelTop: '',
                  imageLabelBottom: '',
                  caption: data['caption'] ?? '',
                  likes: data['likes'] ?? 0,
                  comments: data['comments'] ?? 0,
                  completedVotes: data['completedVotes'] ?? 0,
                  notCompletedVotes: data['failedVotes'] ?? 0,
                  imageUrl: data['imageUrl'],
                  profileImageUrl: data['profileImageUrl'],
                  firestoreId: doc.id,
                  isOwnPost: data['userId'] == FirebaseAuth.instance.currentUser?.uid,
                  isFirestorePost: true,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeScreen.bgColor,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(),

              const StoriesSection(),
              const SizedBox(height: 18),

              _buildTodaySideQuest(),

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

              _buildFirestoreFeed(),
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
              color: const Color(0xFF1A1A1A),
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