import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const SideQuestApp());
}

class SideQuestApp extends StatelessWidget {
  const SideQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SideQuest',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050608),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color bgColor = Color(0xFF050608);

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
            children: const [
              HeaderSection(),
              SizedBox(height: 18),
              StreakStatusSection(),
              SizedBox(height: 18),
              StoriesSection(),
              SizedBox(height: 18),
              TodayQuestCard(),
              SizedBox(height: 20),
              MissionsHeader(),
              SizedBox(height: 14),
              MissionPostCard(
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
              SizedBox(height: 14),
              MissionPostCard(
                userName: 'Sarah Kim',
                timeAgo: '42m ago',
                location: 'Old Town',
                title: 'SMILE HUNT',
                imageEmoji: '📸',
                imageLabelTop: 'M O M E N T',
                imageLabelBottom: 'LIGHT  •  JOY  •  CITY',
                caption:
                'Today’s quest actually worked. Random little things made me smile all day.',
                likes: 89,
                comments: 11,
                completedVotes: 17,
                notCompletedVotes: 2,
              ),
              SizedBox(height: 14),
              MissionPostCard(
                userName: 'Mike Chen',
                timeAgo: '1h ago',
                location: 'Campus Walk',
                title: 'GOLDEN HOUR',
                imageEmoji: '☀️',
                imageLabelTop: 'C A U G H T',
                imageLabelBottom: 'WARM  •  CALM  •  REAL',
                caption:
                'Took this on the way home. Definitely one of those tiny sidequest moments.',
                likes: 156,
                comments: 26,
                completedVotes: 29,
                notCompletedVotes: 4,
              ),
              SizedBox(height: 14),
              MissionPostCard(
                userName: 'Lara Novak',
                timeAgo: '2h ago',
                location: 'Coffee Corner',
                title: 'LITTLE JOYS',
                imageEmoji: '☕',
                imageLabelTop: 'S L O W',
                imageLabelBottom: 'COZY  •  QUIET  •  SWEET',
                caption:
                'A cinnamon roll, good music, and a calm morning. Mission absolutely completed.',
                likes: 73,
                comments: 9,
                completedVotes: 13,
                notCompletedVotes: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1A222B),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: const Icon(
            Icons.explore_rounded,
            color: Color(0xFF18D7FF),
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'SideQuest',
          style: TextStyle(
            color: Color(0xFF18D7FF),
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_rounded,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class StreakStatusSection extends StatelessWidget {
  const StreakStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '05',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'DAY STREAK',
                style: TextStyle(
                  color: Color(0xFF727780),
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'STATUS',
              style: TextStyle(
                color: Color(0xFF18D7FF),
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Ready for Adventure',
              style: TextStyle(
                color: Color(0xFF18D7FF),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = [
      const StoryItem(
        name: 'Your Quest',
        isAdd: true,
      ),
      const StoryItem(name: 'Sarah'),
      const StoryItem(name: 'Mike'),
      const StoryItem(name: 'Lara'),
      const StoryItem(name: 'Nina'),
      const StoryItem(name: 'Alex'),
    ];

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) => stories[index],
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  final String name;
  final bool isAdd;

  const StoryItem({
    super.key,
    required this.name,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isAdd
                  ? const LinearGradient(
                colors: [Color(0xFF18D7FF), Color(0xFF0B2C35)],
              )
                  : const LinearGradient(
                colors: [Color(0xFFFF9B8F), Color(0xFF18D7FF)],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF101317),
              ),
              child: isAdd
                  ? const Icon(Icons.add, color: Color(0xFF18D7FF), size: 22)
                  : const CircleAvatar(
                backgroundColor: Color(0xFF222831),
                child: Icon(
                  Icons.person,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFB8BDC6),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TodayQuestCard extends StatefulWidget {
  const TodayQuestCard({super.key});

  @override
  State<TodayQuestCard> createState() => _TodayQuestCardState();
}

class _TodayQuestCardState extends State<TodayQuestCard> {
  late Timer _timer;
  Duration _remaining = const Duration(hours: 23, minutes: 58, seconds: 12);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours  :  $minutes  :  $seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A171B),
            Color(0xFF101317),
            Color(0xFF0A1618),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF18D7FF).withOpacity(0.08),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: const Text(
              "TODAY'S SIDEQUEST",
              style: TextStyle(
                color: Color(0xFF18D7FF),
                fontSize: 12,
                letterSpacing: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF18D7FF).withOpacity(0.16),
                  blurRadius: 26,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Color(0xFFFF8D84),
              size: 38,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Take a photo of\nsomething that made\nyou smile today',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Capture a moment of joy and share it\nwith the world.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8A8F98),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'QUEST EXPIRES IN',
            style: TextStyle(
              color: Color(0xFF5D626B),
              fontSize: 11,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatTime(_remaining),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF9B8F),
                  Color(0xFF18D7FF),
                ],
              ),
            ),
            child: const Center(
              child: Text(
                'Start Quest',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MissionsHeader extends StatelessWidget {
  const MissionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Text(
            "Today's Missions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          'LIVE FEED',
          style: TextStyle(
            color: Color(0xFF18D7FF),
            fontSize: 11,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class MissionPostCard extends StatelessWidget {
  final String userName;
  final String timeAgo;
  final String location;
  final String title;
  final String imageEmoji;
  final String imageLabelTop;
  final String imageLabelBottom;
  final String caption;
  final int likes;
  final int comments;
  final int completedVotes;
  final int notCompletedVotes;

  const MissionPostCard({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.location,
    required this.title,
    required this.imageEmoji,
    required this.imageLabelTop,
    required this.imageLabelBottom,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.completedVotes,
    required this.notCompletedVotes,
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
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$timeAgo  •  $location',
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
                  title,
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
                      imageEmoji,
                      style: const TextStyle(fontSize: 58),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  imageLabelTop,
                  style: const TextStyle(
                    color: Color(0xFFE8E1D6),
                    fontSize: 10,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  imageLabelBottom,
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
              _PostStat(
                icon: Icons.favorite,
                value: '$likes',
                iconColor: const Color(0xFFFF8D84),
              ),
              const SizedBox(width: 8),
              _PostStat(
                icon: Icons.mode_comment_rounded,
                value: '$comments',
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
            caption,
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
                  'Did they complete the challenge?',
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
                      child: _VoteButton(
                        label: 'Completed',
                        count: completedVotes,
                        color: const Color(0xFF18D7FF),
                        icon: Icons.check_circle_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _VoteButton(
                        label: 'Not yet',
                        count: notCompletedVotes,
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

class _PostStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color iconColor;

  const _PostStat({
    required this.icon,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _VoteButton({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label  ($count)',
            style: TextStyle(
              color: color,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111317),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: const [
          Expanded(child: NavItem(icon: Icons.home_rounded, label: 'HOME', isActive: true)),
          Expanded(child: NavItem(icon: Icons.dynamic_feed_rounded, label: 'FEED')),
          Expanded(child: NavItem(icon: Icons.add_circle, label: 'CREATE', isCenter: true)),
          Expanded(child: NavItem(icon: Icons.groups_rounded, label: 'GROUPS')),
          Expanded(child: NavItem(icon: Icons.person_rounded, label: 'PROFILE')),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCenter;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isCenter
        ? const Color(0xFFFF6E7A)
        : isActive
        ? const Color(0xFF18D7FF)
        : const Color(0xFF6D727B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: activeColor,
          size: isCenter ? 30 : 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: activeColor,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}