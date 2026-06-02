import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../models/activity_item.dart';
import 'activity_card.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  Future<List<ActivityItem>> _loadActivities({
    required BuildContext context,
    required String currentUserID,
    required List<String> followerIDs,
  }) async {
    final List<ActivityItem> activities = [];

    await _addFollowerActivities(
      context: context,
      activities: activities,
      currentUserID: currentUserID,
      followerIDs: followerIDs,
    );

    await _addPostActivities(
      context: context,
      activities: activities,
      currentUserID: currentUserID,
    );

    activities.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

      return bDate.compareTo(aDate);
    });

    return activities;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _watchPendingGroupInvites(
      String currentUserID,
      ) {
    return FirebaseFirestore.instance
        .collection('challengeInvites')
        .where('toUserId', isEqualTo: currentUserID)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> _acceptGroupInvite({
    required String inviteId,
    required String runId,
    required String currentUserID,
  }) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('challengeInvites').doc(inviteId).update({
      'status': 'accepted',
      'respondedAt': FieldValue.serverTimestamp(),
    });

    final runRef = firestore.collection('group_challenge_runs').doc(runId);

    await runRef.update({
      'acceptedUserIds': FieldValue.arrayUnion([currentUserID]),
      'participantIds': FieldValue.arrayUnion([currentUserID]),
    });

    final runDoc = await runRef.get();
    final data = runDoc.data();

    if (data == null) return;

    final invitedUserIds = List<String>.from(
      (data['invitedUserIds'] ?? []).map((e) => e.toString()),
    );

    final acceptedUserIds = List<String>.from(
      (data['acceptedUserIds'] ?? []).map((e) => e.toString()),
    );

    final updatedAcceptedUserIds = {...acceptedUserIds, currentUserID}.toList();

    final allAccepted = invitedUserIds.isNotEmpty &&
        invitedUserIds.every((id) => updatedAcceptedUserIds.contains(id));

    if (allAccepted && data['startedAt'] == null) {
      final now = Timestamp.now();
      final expiresAt = Timestamp.fromDate(
        now.toDate().add(const Duration(hours: 24)),
      );

      await runRef.update({
        'status': 'active',
        'startedAt': now,
        'expiresAt': expiresAt,
      });
    }
  }

  Future<void> _declineGroupInvite({
    required String inviteId,
    required String runId,
    required String currentUserID,
  }) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('challengeInvites').doc(inviteId).update({
      'status': 'declined',
      'respondedAt': FieldValue.serverTimestamp(),
    });

    await firestore.collection('group_challenge_runs').doc(runId).update({
      'declinedUserIds': FieldValue.arrayUnion([currentUserID]),
    });
  }

  Future<void> _addFollowerActivities({
    required BuildContext context,
    required List<ActivityItem> activities,
    required String currentUserID,
    required List<String> followerIDs,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    for (final followerID in followerIDs) {
      if (followerID == currentUserID) {
        continue;
      }

      String username = l10n.unknownUser;

      final followerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(followerID)
          .get();

      if (followerDoc.exists) {
        final followerData = followerDoc.data();
        final foundUsername = followerData?['username']?.toString();

        if (foundUsername != null && foundUsername.trim().isNotEmpty) {
          username = foundUsername;
        }
      }

      activities.add(
        ActivityItem(
          icon: Icons.person_add_alt_1_rounded,
          title: l10n.userStartedFollowingYou(username),
          text: l10n.youHaveANewFollower,
          time: l10n.follower,
        ),
      );
    }
  }

  Future<void> _addPostActivities({
    required BuildContext context,
    required List<ActivityItem> activities,
    required String currentUserID,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final postSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: currentUserID)
        .get();

    for (final postDoc in postSnapshot.docs) {
      final postData = postDoc.data();

      final postCaption = postData['caption']?.toString() ?? '';
      final questTitle = postData['questTitle']?.toString() ?? '';
      final postTitle = questTitle.isNotEmpty ? questTitle : l10n.yourPost;

      await _addLikeActivities(
        context: context,
        activities: activities,
        currentUserID: currentUserID,
        postData: postData,
        postTitle: postTitle,
        postCaption: postCaption,
      );

      await _addCommentActivities(
        context: context,
        activities: activities,
        currentUserID: currentUserID,
        postID: postDoc.id,
        postTitle: postTitle,
      );
    }
  }

  Future<void> _addLikeActivities({
    required BuildContext context,
    required List<ActivityItem> activities,
    required String currentUserID,
    required Map<String, dynamic> postData,
    required String postTitle,
    required String postCaption,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final rawLikedBy = postData['likedBy'];
    final List<String> likedBy = [];

    if (rawLikedBy is List) {
      for (final likerID in rawLikedBy) {
        likedBy.add(likerID.toString());
      }
    }

    for (final likerID in likedBy) {
      if (likerID == currentUserID) {
        continue;
      }

      final likerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(likerID)
          .get();

      if (!likerDoc.exists) {
        continue;
      }

      final likerData = likerDoc.data();
      final username = likerData?['username']?.toString();

      if (username == null || username.trim().isEmpty) {
        continue;
      }

      activities.add(
        ActivityItem(
          icon: Icons.favorite_border_rounded,
          title: l10n.userLikedYourPost(username),
          text: postCaption.isEmpty ? postTitle : '"$postCaption"',
          time: l10n.like,
          createdAt: _timestampToDateTime(postData['createdAt']),
        ),
      );
    }
  }

  Future<void> _addCommentActivities({
    required BuildContext context,
    required List<ActivityItem> activities,
    required String currentUserID,
    required String postID,
    required String postTitle,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final commentsSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();

    for (final commentDoc in commentsSnapshot.docs) {
      final commentData = commentDoc.data();

      final commentUserID = commentData['userId']?.toString();

      if (commentUserID == null || commentUserID == currentUserID) {
        continue;
      }

      final username = commentData['username']?.toString();
      final text = commentData['text']?.toString() ?? '';

      if (username == null || username.trim().isEmpty) {
        continue;
      }

      activities.add(
        ActivityItem(
          icon: Icons.chat_bubble_outline_rounded,
          title: l10n.userCommentedOnPost(username, postTitle),
          text: '"$text"',
          time: _formatTime(context, commentData['createdAt']),
          createdAt: _timestampToDateTime(commentData['createdAt']),
        ),
      );
    }
  }

  DateTime? _timestampToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return null;
  }

  String _formatTime(BuildContext context, dynamic value) {
    final l10n = AppLocalizations.of(context)!;
    final date = _timestampToDateTime(value);

    if (date == null) {
      return l10n.now;
    }

    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    }

    if (difference.inMinutes < 60) {
      return l10n.minutesAgo(difference.inMinutes);
    }

    if (difference.inHours < 24) {
      return l10n.hoursAgo(difference.inHours);
    }

    if (difference.inDays == 1) {
      return l10n.yesterday;
    }

    return l10n.daysAgo(difference.inDays);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(
        child: Text(
          l10n.youNeedToBeLoggedInToSeeActivity,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF18D7FF),
            ),
          );
        }

        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Center(
            child: Text(
              l10n.yourActivityCouldNotBeLoaded,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          );
        }

        final userData = userSnapshot.data!.data();

        final rawFollowers = userData?['followers'];
        final List<String> followerIDs = [];

        if (rawFollowers is List) {
          for (final follower in rawFollowers) {
            followerIDs.add(follower.toString());
          }
        }

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('userId', isEqualTo: currentUser.uid)
              .snapshots(),
          builder: (context, postsSnapshot) {
            if (postsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF18D7FF),
                ),
              );
            }

            return FutureBuilder<List<ActivityItem>>(
              future: _loadActivities(
                context: context,
                currentUserID: currentUser.uid,
                followerIDs: followerIDs,
              ),
              builder: (context, activitySnapshot) {
                if (activitySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF18D7FF),
                    ),
                  );
                }

                if (activitySnapshot.hasError) {
                  return Center(
                    child: Text(
                      l10n.activityCouldNotBeLoaded,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                final activities = activitySnapshot.data ?? [];

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _watchPendingGroupInvites(currentUser.uid),
                  builder: (context, inviteSnapshot) {
                    final invites = inviteSnapshot.data?.docs ?? [];

                    if (invites.isEmpty && activities.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        children: [
                          const SizedBox(height: 80),
                          Icon(
                            Icons.notifications_none_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 42,
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: Text(
                              l10n.noActivitiesYet,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      children: [
                        for (final invite in invites)
                          _GroupInviteCard(
                            inviteDoc: invite,
                            onAccept: () async {
                              final data = invite.data();
                              await _acceptGroupInvite(
                                inviteId: invite.id,
                                runId: data['runId']?.toString() ?? '',
                                currentUserID: currentUser.uid,
                              );
                            },
                            onDecline: () async {
                              final data = invite.data();
                              await _declineGroupInvite(
                                inviteId: invite.id,
                                runId: data['runId']?.toString() ?? '',
                                currentUserID: currentUser.uid,
                              );
                            },
                          ),

                        for (final activity in activities)
                          ActivityCard(activity: activity),
                      ],
                    );
                  },
                );

              },
            );
          },
        );
      },
    );
  }
}

class _GroupInviteCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> inviteDoc;
  final Future<void> Function() onAccept;
  final Future<void> Function() onDecline;

  const _GroupInviteCard({
    required this.inviteDoc,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final data = inviteDoc.data();

    final fromUsername = data['fromUsername']?.toString() ?? 'Someone';
    final title = data['title']?.toString() ?? 'Group SideQuest';
    final description = data['description']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.primary.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.primary.withOpacity(0.13),
                child: Icon(Icons.groups_rounded, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$fromUsername invited you to a Group SideQuest',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            description,
            style: TextStyle(
              color: colors.onSurface.withOpacity(0.58),
              fontSize: 12,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.onSurface.withOpacity(0.75),
                    side: BorderSide(
                      color: colors.onSurface.withOpacity(0.18),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
