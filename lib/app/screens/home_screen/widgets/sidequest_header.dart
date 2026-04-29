import 'package:flutter/material.dart';

class SideQuestHeader extends StatelessWidget {
  const SideQuestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Text(
            "Today's SideQuests",
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