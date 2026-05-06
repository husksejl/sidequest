import 'package:flutter/material.dart';
import '../models/profile_post.dart';

class ProfilePostTile extends StatelessWidget {
  final ProfilePost post;
  final VoidCallback onTap;

  const ProfilePostTile({
    super.key,
    required this.post,
    required this.onTap,
  });

  Color? get borderColor {
    switch (post.voteStatus) {
      case VoteStatus.completed:
        return const Color(0xFF00B2AA);
      case VoteStatus.failed:
        return const Color(0xFFEB5D4F);
      case VoteStatus.undecided:
        return null;
    }
  }

  IconData? get overlayIcon {
    switch (post.type) {
      case ProfilePostType.video:
        return Icons.play_arrow_rounded;
      case ProfilePostType.audio:
        return Icons.graphic_eq_rounded;
      case ProfilePostType.text:
        return Icons.title_rounded;
      case ProfilePostType.image:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: borderColor == null
              ? null
              : Border.all(
            color: borderColor!,
            width: 1.6,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                post.assetPath,
                fit: BoxFit.cover,
              ),
              if (overlayIcon != null)
                Container(
                  color: Colors.black.withOpacity(0.35),
                  child: Icon(
                    overlayIcon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}