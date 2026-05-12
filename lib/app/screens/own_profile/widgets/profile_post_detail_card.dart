import 'package:flutter/material.dart';
import '../models/profile_post.dart';
import 'dart:io';
import '../../../data/profile_post_storage.dart';
import '../own_profile_page.dart';

class ProfilePostDetailCard extends StatefulWidget {
  final ProfilePost post;

  const ProfilePostDetailCard({
    super.key,
    required this.post,
  });

  @override
  State<ProfilePostDetailCard> createState() => _ProfilePostDetailCardState();
}

class _ProfilePostDetailCardState extends State<ProfilePostDetailCard> {
  bool isLiked = false;

  ProfilePost get post => widget.post;

  Color get statusColor {
    switch (post.voteStatus) {
      case VoteStatus.completed:
        return const Color(0xFF00B2AA);
      case VoteStatus.failed:
        return const Color(0xFFEB5D4F);
      case VoteStatus.open:
        return const Color(0xFF00B2AA);
      case VoteStatus.undecided:
        return const Color(0xFF8A8F98);
    }
  }

  String get statusText {
    if (post.votingOpen) return 'Voting open';

    switch (post.voteStatus) {
      case VoteStatus.completed:
        return 'Quest completed';
      case VoteStatus.failed:
        return 'Quest failed';
      case VoteStatus.open:
        return 'Voting open';
      case VoteStatus.undecided:
        return 'Vote undecided';
    }
  }

  int get xpValue {
    switch (post.voteStatus) {
      case VoteStatus.completed:
        return 100;

      case VoteStatus.open:
        return 50;

      case VoteStatus.undecided:
        return 50;

      case VoteStatus.failed:
        return 0;
    }
  }

  Color get xpColor {
    if (xpValue == 100) return const Color(0xFF00B2AA);
    if (xpValue == 50) return Colors.white70;
    return const Color(0xFFEB5D4F);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0E12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage('assets/images/Max.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${post.timeAgo} • ${post.location}',
                        style: const TextStyle(
                          color: Color(0xFF8A8F98),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: xpColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: xpColor.withOpacity(0.7)),
                      ),
                      child: Text(
                        '+$xpValue XP',
                        style: TextStyle(
                          color: xpColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      post.type == ProfilePostType.video
                          ? Icons.play_arrow_rounded
                          : post.type == ProfilePostType.audio
                          ? Icons.graphic_eq_rounded
                          : post.type == ProfilePostType.text
                          ? Icons.title_rounded
                          : Icons.image_rounded,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEB5D4F).withOpacity(0.14),
                    const Color(0xFF050608),
                    const Color(0xFF00B2AA).withOpacity(0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Image.asset(
                        'assets/images/LOGO.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),

                        Text(
                          post.questTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: post.type == ProfilePostType.text || post.type == ProfilePostType.audio
                  ? Container(
                height: 390,
                width: double.infinity,
                padding: const EdgeInsets.all(28),
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
                      right: -10,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEB5D4F).withOpacity(0.16),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00B2AA).withOpacity(0.14),
                        ),
                      ),
                    ),
                    Center(
                      child: post.type == ProfilePostType.audio
                          ? const Icon(
                        Icons.graphic_eq_rounded,
                        color: Colors.white,
                        size: 92,
                      )
                          : const Text(
                        '"I complimented\nthree strangers today\nand honestly...\nit healed me a little."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          height: 1.35,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : SizedBox(
                height: 390,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    post.assetPath.startsWith('assets/')
                        ? Image.asset(
                      post.assetPath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Image.file(
                      File(post.assetPath),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    Positioned(
                      top: 12,
                      right: 12,
                      child: PopupMenuButton<String>(
                        color: const Color(0xFF15181D),
                        icon: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'delete') {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF101216),
                                  title: const Text(
                                    'Delete post?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    'This post will be removed from your profile.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ProfilePostStorage.posts.remove(widget.post);

                                        Navigator.pop(context);

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const OwnProfilePage(),
                                          ),
                                              (route) => false,
                                        );
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Color(0xFFEB5D4F)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          if (value == 'edit') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Edit caption coming soon')),
                            );
                          }

                          if (value == 'save') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Save image coming soon')),
                            );
                          }

                          if (value == 'share') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Share post coming soon')),
                            );
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit caption'),
                          ),
                          PopupMenuItem(
                            value: 'save',
                            child: Text('Save image'),
                          ),
                          PopupMenuItem(
                            value: 'share',
                            child: Text('Share post'),
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Delete post',
                              style: TextStyle(color: Color(0xFFEB5D4F)),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (post.type == ProfilePostType.video)
                    Container(
                      color: Colors.black.withOpacity(0.18),
                      child: Center(
                        child: Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 46,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  child: _SmallStat(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                    value: '${widget.post.likes + (isLiked ? 1 : 0)}',
                    color: const Color(0xFFEB5D4F),
                  ),
                ),
                const SizedBox(width: 8),
                _SmallStat(
                  icon: Icons.chat_bubble_outline_rounded,
                  value: '${post.comments}',
                  color: const Color(0xFF00B2AA),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                post.caption,
                style: const TextStyle(
                  color: Color(0xFFC8CDD5),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),

            if (post.votingOpen) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _VotePreviewButton(
                        label: 'Complete',
                        color: const Color(0xFF00B2AA),
                        icon: Icons.check_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _VotePreviewButton(
                        label: 'Fail',
                        color: const Color(0xFFEB5D4F),
                        icon: Icons.close_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _SmallStat({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _VotePreviewButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _VotePreviewButton({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}