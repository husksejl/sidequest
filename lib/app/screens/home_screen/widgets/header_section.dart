import 'package:flutter/material.dart';

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