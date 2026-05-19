import 'package:flutter/material.dart';
import '../models/profile_post.dart';
import 'dart:io';
import '../../../data/profile_post_storage.dart';
import '../own_profile_page.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../home_screen/widgets/comments_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';


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
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlayingAudio = false;

  Future<void> toggleAudio() async {
    final audioUrl = post.assetPath.trim();

    if (audioUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No audio URL found')),
      );
      return;
    }

    if (isPlayingAudio) {
      await audioPlayer.stop();
      setState(() => isPlayingAudio = false);
      return;
    }

    try {
      await audioPlayer.play(UrlSource(audioUrl));
      setState(() => isPlayingAudio = true);

      audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) setState(() => isPlayingAudio = false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Audio failed: $e')),
      );
    }
  }

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

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }


  int get xpValue {
    if (post.votingOpen) return -1;

    switch (post.voteStatus) {
      case VoteStatus.completed:
        return 100;
      case VoteStatus.undecided:
        return post.completedVotes == 0 &&
            post.notCompletedVotes == 0
            ? 0
            : 50;
      case VoteStatus.failed:
      case VoteStatus.open:
        return 0;
    }
  }

  Color get xpColor {
    if (xpValue == 100) return const Color(0xFF00B2AA);
    if (xpValue == 50) return const Color(0xFF00B2AA);

    if (xpValue == 0 &&
        post.voteStatus == VoteStatus.undecided) {
      return Colors.white70;
    }

    return const Color(0xFFEB5D4F);
  }

  bool get hasVotes =>
      post.completedVotes > 0 || post.notCompletedVotes > 0;

  bool get isTie =>
      !post.votingOpen && post.voteStatus == VoteStatus.undecided && hasVotes;

  bool get hasFrame =>
      post.votingOpen ||
          post.voteStatus == VoteStatus.completed ||
          post.voteStatus == VoteStatus.failed ||
          isTie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0E12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF111317),
                  backgroundImage: post.profileImageUrl != null &&
                      post.profileImageUrl!.isNotEmpty
                      ? NetworkImage(post.profileImageUrl!)
                      : null,
                  child: post.profileImageUrl == null ||
                      post.profileImageUrl!.isEmpty
                      ? const Icon(
                    Icons.person_rounded,
                    color: Colors.white54,
                  )
                      : null,
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
                        post.location.isEmpty
                            ? post.timeAgo
                            : '${post.timeAgo} • ${post.location}',
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
                    if (!post.votingOpen)
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

            Container(
              padding: EdgeInsets.all(hasFrame ? 3 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),

                gradient: isTie
                    ? const LinearGradient(
                  colors: [
                    Color(0xFFEB5D4F),
                    Color(0xFF00B2AA),
                  ],
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
                  isTie ? 4 : (hasFrame ? 2 : 0),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0E12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
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
                                  content: Text(
                                    post.votingOpen
                                        ? 'Deleting this post will allow you to redo this SideQuest.'
                                        : 'Voting for this SideQuest has already ended.\n\nIf you delete this post now, it will be gone forever and you cannot complete this SideQuest again.',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          if (post.firestoreId == null) return;

                                          final postRef = FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(post.firestoreId);

                                          final postSnapshot = await postRef.get();
                                          final postData = postSnapshot.data();

                                          final votingEndsAt = postData?['votingEndsAt'];
                                          final votingIsStillOpen = votingEndsAt == null
                                              ? true
                                              : DateTime.now().isBefore(votingEndsAt.toDate());

                                          final currentUserId =
                                              FirebaseAuth.instance.currentUser?.uid;
                                          final questId = postData?['questId'];

                                          if (votingIsStillOpen &&
                                              currentUserId != null &&
                                              questId != null) {
                                            final completedSnapshot = await FirebaseFirestore
                                                .instance
                                                .collection('completed_sidequest')
                                                .where('userID', isEqualTo: currentUserId)
                                                .where('sideQuestID', isEqualTo: questId)
                                                .get();

                                            for (final doc in completedSnapshot.docs) {
                                              await doc.reference.delete();
                                            }
                                          }

                                          await postRef.delete();

                                          ProfilePostStorage.posts.remove(widget.post);

                                          if (!context.mounted) return;

                                          Navigator.pop(context);

                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const OwnProfilePage(),
                                            ),
                                                (route) => false,
                                          );
                                        } catch (e) {
                                          if (!context.mounted) return;

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Delete failed: $e')),
                                          );
                                        }
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

                          if (value == 'share') {
                            await Share.share(
                              'Check out this SideQuest post:\n\n${post.caption}\n\n${post.assetPath}',
                            );
                          }
                        },
                        itemBuilder: (context) => post.votingOpen
                            ? const [
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
                        ]
                            : const [
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
                    Center(
                      child: post.type == ProfilePostType.audio
                          ? GestureDetector(
                        onTap: toggleAudio,
                        child: Icon(
                          isPlayingAudio
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 92,
                        ),
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
                    post.assetPath.startsWith('http')
                        ? Image.network(
                      post.assetPath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : post.assetPath.startsWith('assets/')
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
                          if (value == 'share') {
                            await Share.share(
                              'Check out this SideQuest post:\n\n${post.caption}\n\n${post.assetPath}',
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
                                  content: Text(
                                    post.votingOpen
                                        ? 'Deleting this post will allow you to redo this SideQuest.'
                                        : 'Voting for this SideQuest has already ended.\n\nIf you delete this post now, it will be gone forever and you cannot complete this SideQuest again.',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          if (post.firestoreId == null) return;

                                          final postRef = FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(post.firestoreId);

                                          final postSnapshot = await postRef.get();
                                          final postData = postSnapshot.data();

                                          final votingEndsAt = postData?['votingEndsAt'];
                                          final votingIsStillOpen = votingEndsAt == null
                                              ? true
                                              : DateTime.now().isBefore(votingEndsAt.toDate());

                                          final currentUserId =
                                              FirebaseAuth.instance.currentUser?.uid;
                                          final questId = postData?['questId'];

                                          if (votingIsStillOpen &&
                                              currentUserId != null &&
                                              questId != null) {
                                            final completedSnapshot = await FirebaseFirestore
                                                .instance
                                                .collection('completed_sidequest')
                                                .where('userID', isEqualTo: currentUserId)
                                                .where('sideQuestID', isEqualTo: questId)
                                                .get();

                                            for (final doc in completedSnapshot.docs) {
                                              await doc.reference.delete();
                                            }
                                          }

                                          await postRef.delete();
                                          ProfilePostStorage.posts.remove(widget.post);

                                          if (!context.mounted) return;

                                          Navigator.pop(context);

                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const OwnProfilePage(),
                                            ),
                                                (route) => false,
                                          );
                                        } catch (e) {
                                          if (!context.mounted) return;

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Delete failed: $e')),
                                          );
                                        }
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
                        itemBuilder: (context) => post.votingOpen
                            ? const [
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
                        ]
                            : const [
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
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: post.firestoreId == null
                      ? null
                      : FirebaseFirestore.instance
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

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: post.firestoreId == null
                  ? null
                  : FirebaseFirestore.instance
                  .collection('posts')
                  .doc(post.firestoreId)
                  .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data();

                final completedVotes = data?['completedVotes'] ?? post.completedVotes;
                final failedVotes = data?['failedVotes'] ?? post.notCompletedVotes;

                return Row(
                  children: [
                    _SmallStat(
                      icon: Icons.check_rounded,
                      value: '$completedVotes',
                      color: const Color(0xFF00B2AA),
                    ),
                    const SizedBox(width: 8),
                    _SmallStat(
                      icon: Icons.close_rounded,
                      value: '$failedVotes',
                      color: const Color(0xFFEB5D4F),
                    ),
                  ],
                );
              },
            ),
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