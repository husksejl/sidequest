import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

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
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF18D7FF).withOpacity(0.16),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ],
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
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.white.withOpacity(0.09)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white70,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}
