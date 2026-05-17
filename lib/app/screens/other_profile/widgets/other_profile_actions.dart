import 'package:flutter/material.dart';

class OtherProfileActions extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onFollowTap;
  final VoidCallback onMessageTap;

  const OtherProfileActions({
    super.key,
    required this.isFollowing,
    required this.onFollowTap,
    required this.onMessageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onFollowTap,
            style: ElevatedButton.styleFrom(
              backgroundColor:
              isFollowing ? Colors.transparent : const Color(0xFFEB5D4F),
              foregroundColor:
              isFollowing ? const Color(0xFFEB5D4F) : Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Color(0xFFEB5D4F)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              isFollowing ? 'FOLLOWING' : 'FOLLOW',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: onMessageTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF00B2AA)),
              foregroundColor: const Color(0xFF00B2AA),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text(
              'MESSAGE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}