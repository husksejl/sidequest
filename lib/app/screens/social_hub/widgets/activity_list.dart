import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/activity_item.dart';
import 'activity_card.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  Future<List<ActivityItem>> _loadActivities({
    required String currentUserID,
    required List<String> followerIDs,
  }) async {
    final List<ActivityItem> activities = [];

    await _addFollowerActivities(
      activities: activities,
      currentUserID: currentUserID,
      followerIDs: followerIDs,
    );

    await _addPostActivities(
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
    required List<ActivityItem> activities,
    required String currentUserID,
    required List<String> followerIDs,
  }) async {
    for (final followerID in followerIDs) {
      if (followerID == currentUserID) {
        continue;
      }

      String username = 'Someone';

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
          title: '$username started following you.',
          text: 'You have a new follower.',
          time: 'Follower',
        ),
      );
    }
  }

  Future<void> _addPostActivities({
    required List<ActivityItem> activities,
    required String currentUserID,
  }) async {
    final postsSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: currentUserID)
        .get();

    for (final postDoc in postsSnapshot.docs) {
      final postData = postDoc.data();

      final postCaption = postData['caption']?.toString() ?? '';
      final questTitle = postData['questTitle']?.toString() ?? '';
      final postTitle = questTitle.isNotEmpty ? questTitle : 'your post';

      await _addLikeActivities(
        activities: activities,
        currentUserID: currentUserID,
        postData: postData,
        postTitle: postTitle,
        postCaption: postCaption,
      );

      await _addCommentActivities(
        activities: activities,
        currentUserID: currentUserID,
        postID: postDoc.id,
        postTitle: postTitle,
      );
    }
  }

  Future<void> _addLikeActivities({
    required List<ActivityItem> activities,
    required String currentUserID,
    required Map<String, dynamic> postData,
    required String postTitle,
    required String postCaption,
  }) async {
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
          title: '$username liked your post.',
          text: postCaption.isEmpty ? postTitle : '"$postCaption"',
          time: 'Like',
          createdAt: _timestampToDateTime(postData['createdAt']),
        ),
      );
    }
  }

  Future<void> _addCommentActivities({
    required List<ActivityItem> activities,
    required String currentUserID,
    required String postID,
    required String postTitle,
  }) async {
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
          title: '$username commented on $postTitle.',
          text: '"$text"',
          time: _formatTime(commentData['createdAt']),
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

  String _formatTime(dynamic value) {
    final date = _timestampToDateTime(value);

    if (date == null) {
      return 'now';
    }

    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    return '${difference.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text(
          'You need to be logged in to see your activity.',
          style: TextStyle(
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
          return const Center(
            child: Text(
              'Your activity could not be loaded.',
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
                  return const Center(
                    child: Text(
                      'Activity could not be loaded.',
                      style: TextStyle(
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
                    children: const [
                      SizedBox(height: 80),
                      Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF18D7FF),
                        size: 42,
                      ),
                      SizedBox(height: 18),
                      Center(
                        child: Text(
                          'No activity yet.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Likes, comments and follows will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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