import 'package:flutter/material.dart';
import '../models/create_quest.dart';

class GroupQuestCard extends StatelessWidget {
  final CreateQuest quest;

  const GroupQuestCard({
    super.key,
    required this.quest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 52, 22, 46),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0).copyWith(
          topRight: const Radius.circular(56),
          bottomLeft: const Radius.circular(56),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF351815),
            Color(0xFF050608),
            Color(0xFF351815),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        children: [
          Text(
            quest.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE5ECEC),
              fontSize: 25,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 34),
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
              shadows: [
                Shadow(
                  color: Color(0xFF00FFF0),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}