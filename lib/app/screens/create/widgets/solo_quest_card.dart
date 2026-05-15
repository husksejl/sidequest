import 'package:flutter/material.dart';

import '../models/create_quest.dart';

class SoloQuestCard extends StatelessWidget {
  final CreateQuest quest;

  const SoloQuestCard({
    super.key,
    required this.quest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(42),
        border: Border.all(
          color: const Color(0xFFEB5D4F),
          width: 7,
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF24100F),
            Color(0xFF050608),
            Color(0xFF24100F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEB5D4F).withOpacity(0.18),
            blurRadius: 35,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            quest.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE5ECEC),
              fontSize: 20,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            quest.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF9DA3AD),
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: Text(
              '${quest.difficulty.toUpperCase()}  •  ${quest.xp} XP',
              style: const TextStyle(
                color: Color(0xFFEB5D4F),
                fontSize: 11,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'QUEST EXPIRES IN',
            style: TextStyle(
              color: Color(0xFF777982),
              fontSize: 13,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            quest.expiresIn,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}