import 'package:flutter/material.dart';
import 'dart:async';

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
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color bgColor = Color(0xFF050608);
  static const Color cardColor = Color(0xFF101216);
  static const Color cyan = Color(0xFF18D7FF);
  static const Color coral = Color(0xFFFF8D84);
  static const Color softText = Color(0xFF8A8F98);
  static const Color white = Colors.white;

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
              const SizedBox(height: 22),
              const StreakStatusSection(),
              const SizedBox(height: 22),
              const TodayQuestCard(),
              const SizedBox(height: 18),
              const SquadCard(),
              const SizedBox(height: 18),
              Row(
                children: const [
                  Expanded(
                    child: SmallInfoCard(
                      icon: Icons.bar_chart_rounded,
                      title: 'Rank',
                      subtitle: 'Top 10% this week',
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: SmallInfoCard(
                      icon: Icons.verified_rounded,
                      title: 'Awards',
                      subtitle: '12 Badges earned',
                    ),
                  ),
                ],
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
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
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

    return '$hours : $minutes : $seconds';
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
        border: Border.all(
          color: Colors.white12,
        ),
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
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
              ),
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
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
              ),
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

class SquadCard extends StatelessWidget {
  const SquadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1114),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Squad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '3 friends are online now',
                  style: TextStyle(
                    color: Color(0xFF8A8F98),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const _Avatar(),
              const SizedBox(width: 6),
              const _Avatar(),
              const SizedBox(width: 6),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '+1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF0C1114), width: 2),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9B8F), Color(0xFF18D7FF)],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF1E2329),
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white70,
          size: 18,
        ),
      ),
    );
  }
}

class SmallInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SmallInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0F13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF18D7FF),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF8A8F98),
              fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111317),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavItem(
            icon: Icons.home_rounded,
            label: 'HOME',
            isActive: true,
          ),
          NavItem(
            icon: Icons.dynamic_feed_rounded,
            label: 'FEED',
          ),
          NavItem(
            icon: Icons.add_circle,
            label: 'CREATE',
            isCenter: true,
          ),
          NavItem(
            icon: Icons.groups_rounded,
            label: 'GROUPS',
          ),
          NavItem(
            icon: Icons.person_rounded,
            label: 'PROFILE',
          ),
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
      children: [
        Icon(
          icon,
          color: activeColor,
          size: isCenter ? 30 : 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
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