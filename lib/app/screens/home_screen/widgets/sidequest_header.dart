import 'package:flutter/material.dart';

class SideQuestHeader extends StatelessWidget {
  const SideQuestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "New SideQuest",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF00B2AA).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFF00B2AA).withValues(alpha: 0.18)),
          ),
          child: const Text(
            'EXPLORE',
            style: TextStyle(
              color: Color(0xFF00B2AA),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
