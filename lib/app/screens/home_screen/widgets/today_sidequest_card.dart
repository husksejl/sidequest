import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../../../shared/models/daily_sidequest.dart';

class TodaySideQuestCard extends StatefulWidget {
  final DailySideQuest sideQuest;
  final VoidCallback onCameraTap;

  const TodaySideQuestCard({
    super.key,
    required this.sideQuest,
    required this.onCameraTap,
  });

  @override
  State<TodaySideQuestCard> createState() => _TodaySideQuestCardState();
}

class _TodaySideQuestCardState extends State<TodaySideQuestCard> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    _updateRemainingTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final difference = nextMidnight.difference(now);

    if (!mounted) return;

    setState(() {
      _remaining = difference.isNegative ? Duration.zero : difference;
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours  :  $minutes  :  $seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3C1F1C),
            Color(0xFF000000),
            Color(0xFF102322),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            child: Text(
              l10n.newSideQuest,
              style: const TextStyle(
                color: Color(0xFF00B2AA),
                fontSize: 12,
                letterSpacing: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: widget.onCameraTap,
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.16),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Color(0xFFEB5D4F),
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            widget.sideQuest.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.sideQuest.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF9DA3AD),
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            l10n.questExpiresIn,
            style: const TextStyle(
              color: Color(0xFF777982),
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatTime(_remaining),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}