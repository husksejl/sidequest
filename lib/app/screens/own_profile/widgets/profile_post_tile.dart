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
      case VoteStatus.open:
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
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: post.voteStatus == VoteStatus.open
              ? const LinearGradient(
            colors: [
              Color(0xFFEB5D4F),
              Color(0xFF00B2AA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: post.voteStatus == VoteStatus.open
              ? null
              : post.voteStatus == VoteStatus.completed
              ? const Color(0xFF00B2AA)
              : post.voteStatus == VoteStatus.failed
              ? const Color(0xFFEB5D4F)
              : Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF050608),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(
              fit: StackFit.expand,
              children: [
                post.type == ProfilePostType.text || post.type == ProfilePostType.audio
                    ? Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFEB5D4F).withOpacity(0.22),
                        const Color(0xFF050608),
                        const Color(0xFF00B2AA).withOpacity(0.18),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFEB5D4F).withOpacity(0.14),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: -25,
                        left: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00B2AA).withOpacity(0.12),
                          ),
                        ),
                      ),

                      Center(
                        child: post.type == ProfilePostType.audio
                            ? const Icon(
                          Icons.graphic_eq_rounded,
                          color: Colors.white,
                          size: 44,
                        )
                            : const Text(
                          '"I complimented\nthree strangers today\nand honestly... it healed me a little."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            height: 1.3,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Image.asset(
                  post.assetPath,
                  fit: BoxFit.cover,
                ),
                if (overlayIcon != null &&
                    post.type != ProfilePostType.audio &&
                    post.type != ProfilePostType.text)
                  Container(
                    color: Colors.black.withOpacity(0.18),
                    child: Center(
                      child: post.type == ProfilePostType.video
                          ? Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      )
                          : Icon(
                        overlayIcon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}