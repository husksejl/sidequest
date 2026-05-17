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
          style: const TextStyle(
            color: Colors.white,
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
              style: const TextStyle(
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
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                final activities = activitySnapshot.data ?? [];

                if (activities.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    children: [
                      const SizedBox(height: 80),
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF18D7FF),
                        size: 42,
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          l10n.noActivitiesYet,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          l10n.activity,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  children: [
                    for (int i = 0; i < activities.length; i++)
                      ActivityCard(activity: activities[i]),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
