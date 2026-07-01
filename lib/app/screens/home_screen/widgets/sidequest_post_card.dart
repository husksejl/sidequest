import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../models/sidequest_post.dart';
import '../../other_profile/other_profile_page.dart';
import 'comments_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../own_profile/own_profile_page.dart';


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

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingAudio = false;

  SideQuestPost get post => widget.post;

  int get xpValue {
    if (post.votingOpen) return -1;

    switch (post.voteStatus) {
      case 'completed':
        return 100;

      case 'undecided':
        return post.completedVotes == 0 &&
            post.notCompletedVotes == 0
            ? 0
            : 50;

      case 'failed':
        return 0;

      default:
        return 0;
    }
  }

  Color get xpColor {
    if (xpValue == 100) return const Color(0xFF00B2AA);
    if (xpValue == 50) return const Color(0xFF00B2AA);

    if (xpValue == 0 &&
        post.voteStatus == 'undecided') {
      return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70);
    }

    return const Color(0xFFEB5D4F);
  }

  Color get statusColor {
    if (post.votingOpen) return const Color(0xFF00B2AA);

    switch (post.voteStatus) {
      case 'completed':
        return const Color(0xFF00B2AA);
      case 'failed':
        return const Color(0xFFEB5D4F);
      case 'undecided':
        return Theme.of(context).colorScheme.onSurface;
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  String statusText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return post.votingOpen ? l10n.votingOpen : l10n.votingClosed;
  }

  bool get hasVotes =>
      post.completedVotes > 0 || post.notCompletedVotes > 0;

  bool get isTie =>
      !post.votingOpen && post.voteStatus == 'undecided' && hasVotes;

  bool get hasFrame =>
      post.votingOpen ||
          post.voteStatus == 'completed' ||
          post.voteStatus == 'failed' ||
          isTie;


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }


  Future<void> deletePost() async {
    if (post.firestoreId == null) return;

    final postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(post.firestoreId);

    final postSnapshot = await postRef.get();
    final postData = postSnapshot.data();

    final votingEndsAt = postData?['votingEndsAt'];

    final votingStillOpen = votingEndsAt == null
        ? true
        : DateTime.now().isBefore(votingEndsAt.toDate());

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final questId = postData?['questId'];

    if (votingStillOpen &&
        currentUserId != null &&
        questId != null) {

      final completedSnapshot = await FirebaseFirestore.instance
          .collection('completed_sidequest')
          .where('userID', isEqualTo: currentUserId)
          .where('sideQuestID', isEqualTo: questId)
          .get();

      for (final doc in completedSnapshot.docs) {
        await doc.reference.delete();
      }
    }

    await postRef.delete();
  }

  Future<void> deleteParticipation() async {
    if (post.firestoreId == null) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    final postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(post.firestoreId);

    await postRef.update({
      'participantIds': FieldValue.arrayRemove([currentUserId]),
      'deletedParticipationUserIds': FieldValue.arrayUnion([currentUserId]),
      'completedVotedBy': FieldValue.arrayRemove([currentUserId]),
      'failedVotedBy': FieldValue.arrayRemove([currentUserId]),
    });
  }

  Future<void> reportPost() async {
    if (post.firestoreId == null) return;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    await FirebaseFirestore.instance.collection('reports').add({
      'postId': post.firestoreId,
      'reportedUserId': post.userId,
      'reportedBy': currentUserId,
      'reason': 'post_reported',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


  Future<void> awardXpIfVotingClosed({
    required Map<String, dynamic> data,
  }) async {
    if (post.firestoreId == null) return;

    final votingEndsAt = data['votingEndsAt'];
    if (votingEndsAt == null) return;

    final isClosed = DateTime.now().isAfter(votingEndsAt.toDate());
    final alreadyAwarded = data['xpAwarded'] == true;

    if (!isClosed || alreadyAwarded) return;

    final completedVotes = data['completedVotes'] ?? 0;
    final failedVotes = data['failedVotes'] ?? 0;
    final ownerId = data['userId'];

    if (ownerId == null) return;

    int earnedXp = 0;

    if (completedVotes > failedVotes) {
      earnedXp = 100;
    } else if (completedVotes == failedVotes && completedVotes > 0) {
      earnedXp = 50;
    } else {
      earnedXp = 0;
    }

    final postRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(post.firestoreId);

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(ownerId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final freshPost = await transaction.get(postRef);

      if (freshPost.data()?['xpAwarded'] == true) return;

      transaction.update(postRef, {
        'xpAwarded': true,
        'earnedXp': earnedXp,
      });

      if (earnedXp > 0) {
        transaction.update(userRef, {
          'xp': FieldValue.increment(earnedXp),
        });
      }
    });
  }


  Future<List<Map<String, dynamic>>> _loadParticipants(List<String> ids) async {
    final users = <Map<String, dynamic>>[];

    for (final id in ids) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
      final data = doc.data();

      if (data != null) {
        users.add({
          'id': id,
          'username': data['username'] ?? data['firstName'] ?? 'Unknown user',
          'profileImageUrl': data['profileImageUrl'] ?? data['profileimageURL'] ?? '',
        });
      }
    }

    return users;
  }

  Widget _buildGroupAvatars() {
    final ids = post.participantIds;
    if (ids.isEmpty) return const SizedBox.shrink();

    final visibleCount = ids.length > 3 ? 3 : ids.length;
    final remainingCount = ids.length - visibleCount;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadParticipants(ids),
      builder: (context, snapshot) {
        final members = snapshot.data ?? [];

        return GestureDetector(
          onTap: () => _showParticipantsSheet(ids),
          child: SizedBox(
            width: 110,
            height: 44,
            child: Stack(
              children: [
                for (int i = 0; i < visibleCount; i++)
                  Positioned(
                    left: i * 26,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: i < members.length &&
                          members[i]['profileImageUrl'].toString().isNotEmpty
                          ? NetworkImage(members[i]['profileImageUrl'])
                          : null,
                      child: i >= members.length ||
                          members[i]['profileImageUrl'].toString().isEmpty
                          ? const Icon(Icons.person_rounded)
                          : null,
                    ),
                  ),
                if (remainingCount > 0)
                  Positioned(
                    left: visibleCount * 26,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF171A20),
                      child: Text(
                        '+$remainingCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showParticipantsSheet(List<String> ids) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0E1014),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _loadParticipants(ids),
          builder: (context, snapshot) {
            final members = snapshot.data ?? [];

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: members.map((member) {
                  return GestureDetector(
                    onTap: () {
                      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                      final tappedUserId = member['id'].toString();

                      Navigator.pop(context);

                      if (tappedUserId == currentUserId) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OwnProfilePage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtherProfilePage(
                              userId: tappedUserId,
                            ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: member['profileImageUrl'].toString().isNotEmpty
                                ? NetworkImage(member['profileImageUrl'])
                                : null,
                            child: member['profileImageUrl'].toString().isEmpty
                                ? const Icon(Icons.person_rounded)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            member['username'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              post.isGroupQuest
                  ? _buildGroupAvatars()
                  : GestureDetector(
                onTap: () {
                  if (post.userId == null) return;

                  if (post.isOwnPost) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OwnProfilePage(),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OtherProfilePage(
                        userId: post.userId!,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.10),
                  backgroundImage: post.profileImageUrl != null &&
                      post.profileImageUrl!.isNotEmpty
                      ? NetworkImage(post.profileImageUrl!)
                      : null,
                  child: post.profileImageUrl == null ||
                      post.profileImageUrl!.isEmpty
                      ? Icon(
                    Icons.person_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.54),
                    size: 24,
                  )
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: post.isGroupQuest
                    ? Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Text(
                    post.timeAgo,
                    style: const TextStyle(
                      color: Color(0xFF8A8F98),
                      fontSize: 11,
                    ),
                  ),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (post.userId == null) return;

                        if (post.isOwnPost) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OwnProfilePage(),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtherProfilePage(
                              userId: post.userId!,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        post.userName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: xpColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: xpColor.withValues(alpha: 0.7)),
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
                    Icons.image_rounded,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
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
                  const Color(0xFFEB5D4F).withValues(alpha: 0.14),
                  Theme.of(context).brightness == Brightness.light ? const Color(0xFFF6F8FA) : const Color(0xFF050608),
                  const Color(0xFF00B2AA).withValues(alpha: 0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
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
                    : statusColor,
                width: 3,
              )
                  : null,
            ),
            child: Container(
              padding: EdgeInsets.all(
                isTie ? 4 : (hasFrame ? 2 : 0),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 390,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (post.mediaType == 'audio')
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFEB5D4F).withValues(alpha: 0.22),
                                Theme.of(context).brightness == Brightness.light ? const Color(0xFFF6F8FA) : const Color(0xFF050608),
                                const Color(0xFF00B2AA).withValues(alpha: 0.18),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () async {
                                final audioUrl = post.audioUrl?.trim();

                                if (audioUrl == null || audioUrl.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No audio URL found')),
                                  );
                                  return;
                                }

                                if (_isPlayingAudio) {
                                  await _audioPlayer.stop();
                                  setState(() => _isPlayingAudio = false);
                                  return;
                                }

                                try {
                                  await _audioPlayer.play(UrlSource(audioUrl));
                                  setState(() => _isPlayingAudio = true);

                                  _audioPlayer.onPlayerComplete.listen((_) {
                                    if (mounted) setState(() => _isPlayingAudio = false);
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Audio failed: $e')),
                                  );
                                }
                              },
                              child: Icon(
                                _isPlayingAudio
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_fill_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 92,
                              ),
                            ),
                          ),
                        )
                      else if (post.isFirestorePost && post.imageUrl != null)
                        Image.network(
                          post.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                      Positioned(
                        top: 12,
                        right: 12,
                        child: PopupMenuButton<String>(
                          color: Theme.of(context).colorScheme.surface,
                          icon: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.70),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.more_horiz_rounded,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 22,
                            ),
                          ),
                          onSelected: (value) async {
                            if (value == 'save') {
                              try {
                                final imagePath = post.imageUrl ?? '';
                                if (imagePath.isEmpty) return;

                                final response = await http.get(Uri.parse(imagePath));
                                final tempDir = await getTemporaryDirectory();

                                final file = File(
                                  '${tempDir.path}/sidequest_${DateTime.now().millisecondsSinceEpoch}.jpg',
                                );

                                await file.writeAsBytes(response.bodyBytes);

                                final success = await GallerySaver.saveImage(
                                  file.path,
                                  albumName: 'SideQuest',
                                );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success == true ? 'Saved to gallery' : 'Could not save image',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Save failed: $e')),
                                );
                              }
                            }

                            if (value == 'share') {
                              final mediaUrl = post.mediaType == 'audio'
                                  ? post.audioUrl
                                  : post.imageUrl;

                              await Share.share(
                                'Check out this SideQuest post:\n\n${post.caption}\n\n${mediaUrl ?? ''}',
                              );
                            }

                            if (value == 'report') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    title: Text(
                                      'Report post?',
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                    ),
                                    content: Text(
                                      'Are you sure you want to report this post?',
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70)),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);

                                          await reportPost();

                                          if (!context.mounted) return;

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Post reported'),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Report',
                                          style: TextStyle(color: Color(0xFFEB5D4F)),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            if (value == 'deleteParticipation') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    title: Text(
                                      'Delete participation?',
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                    ),
                                    content: Text(
                                      'This post will be permanently removed from your profile, but it will stay visible for the other participants.',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await deleteParticipation();
                                        },
                                        child: const Text(
                                          'Delete participation',
                                          style: TextStyle(color: Color(0xFFEB5D4F)),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }


                            if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    title: Text(
                                      'Delete post?',
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                    ),
                                    content: Text(
                                      post.votingOpen
                                          ? 'Deleting this post will allow you to redo this SideQuest.'
                                          : '\nIf you delete this post now, it cannot be restored and this SideQuest cannot be completed again.',
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70)),
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
                          itemBuilder: (context) {
                            final canSaveImage = post.mediaType != 'audio';
                            final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

                            final isParticipant =
                            post.participantIds.contains(currentUserId);

                            final isOwner =
                                post.userId == currentUserId;

                            if (post.isGroupQuest) {
                              return [
                                if (canSaveImage)
                                  const PopupMenuItem(
                                    value: 'save',
                                    child: Text('Save image'),
                                  ),
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Text('Share post'),
                                ),
                                const PopupMenuDivider(),

                                if (isParticipant || isOwner)
                                  const PopupMenuItem(
                                    value: 'deleteParticipation',
                                    child: Text(
                                      'Delete participation',
                                      style: TextStyle(color: Color(0xFFEB5D4F)),
                                    ),
                                  )
                                else
                                  const PopupMenuItem(
                                    value: 'report',
                                    child: Text(
                                      'Report post',
                                      style: TextStyle(color: Color(0xFFEB5D4F)),
                                    ),
                                  ),
                              ];
                            }

                            if (post.isOwnPost) {
                              return [
                                if (canSaveImage)
                                  const PopupMenuItem(
                                    value: 'save',
                                    child: Text('Save image'),
                                  ),
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Text('Share post'),
                                ),
                                const PopupMenuDivider(),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Delete post',
                                    style: TextStyle(color: Color(0xFFEB5D4F)),
                                  ),
                                ),
                              ];
                            }

                            return [
                              if (canSaveImage)
                                const PopupMenuItem(
                                  value: 'save',
                                  child: Text('Save image'),
                                ),
                              const PopupMenuItem(
                                value: 'share',
                                child: Text('Share post'),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem(
                                value: 'report',
                                child: Text(
                                  'Report post',
                                  style: TextStyle(color: Color(0xFFEB5D4F)),
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

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
                  statusText(context).toUpperCase(),
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
              style: TextStyle(
                color: Color(0xFFC8CDD5),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),

          const SizedBox(height: 14),

          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: post.firestoreId == null
                ? null
                : FirebaseFirestore.instance
                .collection('posts')
                .doc(post.firestoreId)
                .snapshots(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data();

              if (data != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  awardXpIfVotingClosed(data: data);
                });
              }

              final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

              final liveParticipantIds = List<String>.from(
                (data?['participantIds'] ?? []).map((e) => e.toString()),
              );

              final deletedParticipationUserIds = List<String>.from(
                (data?['deletedParticipationUserIds'] ?? []).map((e) => e.toString()),
              );

              final isParticipant = liveParticipantIds.contains(currentUserId);

              final hasDeletedParticipation =
              deletedParticipationUserIds.contains(currentUserId);

              final isOwnPostForVoting =
                  post.isOwnPost && !hasDeletedParticipation;

              final completedVotedBy =
              List<String>.from(data?['completedVotedBy'] ?? []);
              final failedVotedBy =
              List<String>.from(data?['failedVotedBy'] ?? []);

              final completedVotes = data?['completedVotes'] ?? 0;
              final failedVotes = data?['failedVotes'] ?? 0;

              final votingEndsAt = data?['votingEndsAt'];
              final votingOpen = votingEndsAt == null
                  ? true
                  : DateTime.now().isBefore(votingEndsAt.toDate());

              final votedComplete = completedVotedBy.contains(currentUserId);
              final votedFail = failedVotedBy.contains(currentUserId);
              final hasVoted = votedComplete || votedFail;

              Future<void> vote(String type) async {
                if (post.firestoreId == null || currentUserId.isEmpty || !votingOpen) {
                  return;
                }

                final postRef = FirebaseFirestore.instance
                    .collection('posts')
                    .doc(post.firestoreId);

                if (type == 'complete') {
                  if (votedComplete) {
                    await postRef.update({
                      'completedVotedBy': FieldValue.arrayRemove([currentUserId]),
                      'completedVotes': FieldValue.increment(-1),
                    });
                  } else {
                    await postRef.update({
                      'completedVotedBy': FieldValue.arrayUnion([currentUserId]),
                      'completedVotes': FieldValue.increment(1),
                      'failedVotedBy': FieldValue.arrayRemove([currentUserId]),
                      if (votedFail) 'failedVotes': FieldValue.increment(-1),
                    });
                  }
                }

                if (type == 'fail') {
                  if (votedFail) {
                    await postRef.update({
                      'failedVotedBy': FieldValue.arrayRemove([currentUserId]),
                      'failedVotes': FieldValue.increment(-1),
                    });
                  } else {
                    await postRef.update({
                      'failedVotedBy': FieldValue.arrayUnion([currentUserId]),
                      'failedVotes': FieldValue.increment(1),
                      'completedVotedBy': FieldValue.arrayRemove([currentUserId]),
                      if (votedComplete) 'completedVotes': FieldValue.increment(-1),
                    });
                  }
                }
              }

              if (isOwnPostForVoting || isParticipant) {
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
              }

              if (!votingOpen) {
                if (!hasVoted) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.notVoted,
                      style: TextStyle(
                        color: Color(0xFF8A8F98),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: _VotePreviewButton(
                        label: votedComplete ? l10n.complete : l10n.fail,
                        color: votedComplete
                            ? const Color(0xFF00B2AA)
                            : const Color(0xFFEB5D4F),
                        icon: votedComplete
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        count: votedComplete ? completedVotes : failedVotes,
                        filled: true,
                      ),
                    ),
                  ],
                );
              }

              if (votedComplete) {
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => vote('complete'),
                        child: _VotePreviewButton(
                          label: l10n.complete,
                          color: const Color(0xFF00B2AA),
                          icon: Icons.check_rounded,
                          count: completedVotes,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (votedFail) {
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => vote('fail'),
                        child: _VotePreviewButton(
                          label: l10n.fail,
                          color: const Color(0xFFEB5D4F),
                          icon: Icons.close_rounded,
                          count: failedVotes,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => vote('complete'),
                        child: _VotePreviewButton(
                          label: l10n.complete,
                          color: const Color(0xFF00B2AA),
                          icon: Icons.check_rounded,
                          count: completedVotes,
                          filled: false,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => vote('fail'),
                        child: _VotePreviewButton(
                          label: l10n.fail,
                          color: const Color(0xFFEB5D4F),
                          icon: Icons.close_rounded,
                          count: failedVotes,
                          filled: false,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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
  final bool filled;

  const _VotePreviewButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.count,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: filled ? color : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: filled ? (Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black) : color,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: filled ? (Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black) : color,
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