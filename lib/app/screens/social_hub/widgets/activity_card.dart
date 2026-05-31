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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.30),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildIcon(context),
          const SizedBox(width: 14),
          Expanded(
            child: buildTextContent(context),
          ),
          const SizedBox(width: 10),
          buildRightSide(context),
        ],
      ),
    );
  }

  Widget buildIcon(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        activity.icon,
        color: const Color(0xFF00E5FF),
        size: 23,
      ),
    );
  }

  Widget buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          activity.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          activity.text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.64),
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget buildRightSide(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          activity.time.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.56),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (activity.actionText != null) ...[
          const SizedBox(height: 14),
          buildActionButton(context),
        ],
      ],
    );
  }

  Widget buildActionButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A66),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A66).withValues(alpha: 0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        activity.actionText!,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}