import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/sidequest_post.dart';
import '../../other_profile/other_profile_page.dart';
import 'comments_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideQuestPostCard extends StatefulWidget {
  final SideQuestPost post;

  const SideQuestPostCard({
    super.key,
    required this.post,
  });

  @override
  State<SideQuestPostCard> createState() => _SideQuestPostCardState();
}

class _SideQuestPostCardState extends State<SideQuestPostCard> {
  bool isLiked = false;

  SideQuestPost get post => widget.post;

  int get xpValue => 50;

  Color get xpColor => Colors.white70;

  Color get statusColor => const Color(0xFF00B2AA);

  String get statusText => 'Voting open';

  Future<void> deletePost() async {
    if (post.firestoreId == null) return;

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.firestoreId)
        .delete();
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
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF1B2026),
                backgroundImage: post.profileImageUrl != null &&
                    post.profileImageUrl!.isNotEmpty
                    ? NetworkImage(post.profileImageUrl!)
                    : null,
                child: post.profileImageUrl == null ||
                    post.profileImageUrl!.isEmpty
                    ? const Icon(
                  Icons.person_rounded,
                  color: Colors.white54,
                  size: 24,
                )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (post.userId == null || post.isOwnPost) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherProfilePage(
                              userId: post.userId!,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        post.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
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
                  const Icon(
                    Icons.image_rounded,
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
                SizedBox(
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
                  child: Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 390,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (post.isFirestorePost && post.imageUrl != null)
                    Image.network(
                      post.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  else
                    Image.asset(
                      post.userName == 'Charles L.'
                          ? 'assets/images/Charles.jpg'
                          : 'assets/images/Max.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                  if (post.isOwnPost)
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
                        onSelected: (value) async {
                          if (value == 'edit') {
                            final TextEditingController captionController =
                            TextEditingController(text: post.caption);

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF101216),
                                  title: const Text(
                                    'Edit caption',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: TextField(
                                    controller: captionController,
                                    maxLines: 3,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Add a caption...',
                                      hintStyle: TextStyle(color: Colors.white38),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (post.firestoreId != null) {
                                          await FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(post.firestoreId)
                                              .update({
                                            'caption': captionController.text.trim(),
                                          });
                                        }

                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(color: Color(0xFF00B2AA)),
                                      ),
                                    ),
                                  ],
                                );
                              },
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
                                    'This post will be removed from your profile and feed.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await deletePost();
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
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(post.firestoreId)
                    .snapshots(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data();

                  final likedBy = List<String>.from(data?['likedBy'] ?? []);
                  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
                  final isLiked = likedBy.contains(currentUserId);
                  final likes = data?['likes'] ?? post.likes;

                  return GestureDetector(
                    onTap: () async {
                      if (post.firestoreId == null || currentUserId.isEmpty) return;

                      final postRef = FirebaseFirestore.instance
                          .collection('posts')
                          .doc(post.firestoreId);

                      if (isLiked) {
                        await postRef.update({
                          'likedBy': FieldValue.arrayRemove([currentUserId]),
                          'likes': FieldValue.increment(-1),
                        });
                      } else {
                        await postRef.update({
                          'likedBy': FieldValue.arrayUnion([currentUserId]),
                          'likes': FieldValue.increment(1),
                        });
                      }
                    },
                    child: _SmallStat(
                      icon: isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                      value: '$likes',
                      color: const Color(0xFFEB5D4F),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (post.firestoreId == null) return;

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CommentsBottomSheet(
                      postId: post.firestoreId!,
                    ),
                  );
                },
                child: _SmallStat(
                  icon: Icons.chat_bubble_outline_rounded,
                  value: '${post.comments}',
                  color: const Color(0xFF00B2AA),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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

          const SizedBox(height: 14),

          if (post.isOwnPost)
            Row(
              children: [
                _SmallStat(
                  icon: Icons.check_rounded,
                  value: '${post.completedVotes}',
                  color: const Color(0xFF00B2AA),
                ),
                const SizedBox(width: 8),
                _SmallStat(
                  icon: Icons.close_rounded,
                  value: '${post.notCompletedVotes}',
                  color: const Color(0xFFEB5D4F),
                ),
              ],
            )
          else
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
                      count: post.completedVotes,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _VotePreviewButton(
                      label: 'Fail',
                      color: const Color(0xFFEB5D4F),
                      icon: Icons.close_rounded,
                      count: post.notCompletedVotes,
                    ),
                  ),
                ],
              ),
            ),
        ],
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
  final int count;

  const _VotePreviewButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.count,
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
            '${label.toUpperCase()} • $count',
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