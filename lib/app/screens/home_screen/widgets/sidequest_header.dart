import 'package:flutter/material.dart';

class SideQuestHeader extends StatelessWidget {
  const SideQuestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "New SideQuest",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const Text(
          'LIVE FEED',
          style: TextStyle(
            color: Color(0xFF00B2AA),
            fontSize: 11,
            letterSpacing: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}