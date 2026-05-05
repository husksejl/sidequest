import 'package:flutter/material.dart';

import '../models/activity_item.dart';

class ActivityCard extends StatelessWidget {
  final ActivityItem activity;

  const ActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111615),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF0B3D40),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: buildTextContent(),
          ),
          const SizedBox(width: 10),
          buildRightSide(),
        ],
      ),
    );
  }

  Widget buildIcon() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF123C40),
        shape: BoxShape.circle,
      ),
      child: Icon(
        activity.icon,
        color: const Color(0xFF00E5FF),
        size: 23,
      ),
    );
  }

  Widget buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          activity.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          activity.text,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget buildRightSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          activity.time.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (activity.actionText != null) ...[
          const SizedBox(height: 14),
          buildActionButton(),
        ],
      ],
    );
  }

  Widget buildActionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A66),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A66).withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        activity.actionText!,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}