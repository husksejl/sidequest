import 'package:flutter/material.dart';

import '../models/story_item_model.dart';

class StoryItem extends StatelessWidget {
  final StoryItemModel story;

  const StoryItem({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: story.isAdd
                  ? const LinearGradient(
                colors: [Color(0xFF00B2AA), Color(0xFF0B2C35)],
              )
                  : const LinearGradient(
                colors: [Color(0xFFEB5D4F), Color(0xFF00B2AA)],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF101317),
              ),
              child: story.isAdd
                  ? Icon(
                Icons.add,
                color: Color(0xFF00B2AA),
                size: 22,
              )
                  : CircleAvatar(
                backgroundColor: Color(0xFF222831),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            story.name.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFFB8BDC6),
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
