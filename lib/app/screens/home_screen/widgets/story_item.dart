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
      width: 62,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: story.isAdd
                  ? const LinearGradient(
                colors: [Color(0xFF18D7FF), Color(0xFF0B2C35)],
              )
                  : const LinearGradient(
                colors: [Color(0xFFFF9B8F), Color(0xFF18D7FF)],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF101317),
              ),
              child: story.isAdd
                  ? const Icon(
                Icons.add,
                color: Color(0xFF18D7FF),
                size: 22,
              )
                  : const CircleAvatar(
                backgroundColor: Color(0xFF222831),
                child: Icon(
                  Icons.person,
                  color: Colors.white70,
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
            style: const TextStyle(
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