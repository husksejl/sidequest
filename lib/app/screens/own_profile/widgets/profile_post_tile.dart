import 'package:flutter/material.dart';
import '../models/profile_post.dart';
import 'dart:io';

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

  bool get hasVotes =>
      post.completedVotes > 0 || post.notCompletedVotes > 0;

  bool get isTie =>
      !post.votingOpen &&
          post.voteStatus == VoteStatus.undecided &&
          hasVotes;

  bool get hasFrame =>
      post.votingOpen ||
          post.voteStatus == VoteStatus.completed ||
          post.voteStatus == VoteStatus.failed ||
          isTie;

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          isTie ? 3 : (hasFrame ? 2 : 0),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: isTie
              ? const LinearGradient(
            colors: [
              Color(0xFFEB5D4F),
              Color(0xFF00B2AA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          border: hasFrame && !isTie
              ? Border.all(
            color: post.votingOpen
                ? const Color(0xFF8A8F98)
                : post.voteStatus == VoteStatus.completed
                ? const Color(0xFF00B2AA)
                : const Color(0xFFEB5D4F),
            width: 2.5,
          )
              : null,
        ),
        child: Container(
          padding: EdgeInsets.all(
            isTie ? 3 : (hasFrame ? 2 : 0),
          ),
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
                  child: Center(
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
                )
                    : post.assetPath.startsWith('http')
                    ? Image.network(
                  post.assetPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
                    : post.assetPath.startsWith('assets/')
                    ? Image.asset(
                  post.assetPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
                    : Image.file(
                  File(post.assetPath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                if (overlayIcon != null &&
                    post.type != ProfilePostType.audio &&
                    post.type != ProfilePostType.text)
                  Container(
                    color: Colors.black.withOpacity(0.18),
                    child: Center(
                      child: Icon(
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