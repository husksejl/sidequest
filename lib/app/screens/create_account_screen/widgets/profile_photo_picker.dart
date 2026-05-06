import 'package:flutter/material.dart';

class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 108,
          height: 108,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF18D7FF),
                Color(0xFFFF9B8F),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF18D7FF).withOpacity(0.18),
                blurRadius: 28,
                spreadRadius: 2,
                offset: const Offset(-8, 0),
              ),
              BoxShadow(
                color: const Color(0xFFFF8D84).withOpacity(0.16),
                blurRadius: 28,
                spreadRadius: 2,
                offset: const Offset(8, 0),
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF111317),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'ADD PROFILE PHOTO',
          style: TextStyle(
            color: Color(0xFF18D7FF),
            fontSize: 13,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
