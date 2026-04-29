import 'dart:async';
import 'package:flutter/material.dart';

class TodaySideQuestCard extends StatefulWidget {
  const TodaySideQuestCard({super.key});

  @override
  State<TodaySideQuestCard> createState() => _TodaySideQuestCardState();
}

class _TodaySideQuestCardState extends State<TodaySideQuestCard> {
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
            'SIDEQUEST EXPIRES IN',
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
                'Start SideQuest',
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