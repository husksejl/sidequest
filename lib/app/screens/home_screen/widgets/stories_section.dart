import 'package:flutter/material.dart';

import '../models/story_item_model.dart';
import 'story_item.dart';

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  static const List<StoryItemModel> stories = [
    StoryItemModel(name: 'Add Story', isAdd: true),
    StoryItemModel(name: 'Sarah'),
    StoryItemModel(name: 'Mike'),
    StoryItemModel(name: 'Lara'),
    StoryItemModel(name: 'Nina'),
    StoryItemModel(name: 'Alex'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return StoryItem(story: stories[index]);
        },
      ),
    );
  }
}