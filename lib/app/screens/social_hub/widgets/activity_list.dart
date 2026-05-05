import 'package:flutter/material.dart';

import '../models/activity_item.dart';
import 'activity_card.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ActivityItem> activities = [
      const ActivityItem(
        icon: Icons.groups_rounded,
        title: 'Group Challenge Invite',
        text: '@alex_void invited you to join Neon Night Pulse.',
        time: 'Just now',
        actionText: 'ACCEPT',
      ),
      const ActivityItem(
        icon: Icons.favorite_border_rounded,
        title: 'Sarah Chen liked your profile update.',
        text: 'Your latest update got some love.',
        time: '2m ago',
      ),
      const ActivityItem(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'Marcus Thorne commented on Urban Explorer quest.',
        text: '"That shortcut through the neon district was legendary!"',
        time: '15m ago',
      ),
      const ActivityItem(
        icon: Icons.person_add_alt_1_rounded,
        title: 'Jordan Park started following you.',
        text: 'You have a new follower.',
        time: '1h ago',
        actionText: 'FOLLOW',
      ),
      const ActivityItem(
        icon: Icons.military_tech_rounded,
        title: 'You earned the Night Crawler badge.',
        text: 'A new badge was added to your profile.',
        time: '20h ago',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        for (int i = 0; i < activities.length; i++)
          ActivityCard(activity: activities[i]),
      ],
    );
  }
}