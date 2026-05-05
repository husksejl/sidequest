import 'package:flutter/material.dart';

class QuestHeaderCard extends StatelessWidget {
  const QuestHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF102326),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF0B3D40),
        ),
      ),
      child: Row(
        children: [
          buildIcon(),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACTIVE SIDEQUEST',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Capture the glow of a neon sign',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          buildProgress(),
        ],
      ),
    );
  }

  Widget buildIcon() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withOpacity(0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.public,
        color: Color(0xFF00E5FF),
        size: 23,
      ),
    );
  }

  Widget buildProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '4/10',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}