import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/custom_bottom_nav.dart';
import 'widgets/other_profile_post_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/other_profile_header.dart';
import '../../shared/widgets/follow_list_sheet.dart';

import '../../shared/services/chat_service.dart';
import '../group_chat/group_chat_page.dart';
import 'widgets/other_profile_actions.dart';
import 'widgets/other_profile_meta.dart';

class OtherProfilePage extends StatelessWidget {
  final String userId;

  const OtherProfilePage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFEB5D4F),
                ),
              );
            }

            final userData = userSnapshot.data!.data();

            if (userData == null) {
              return Center(
                child: Text(
                  'User not found',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              );
            }

            final username = userData['username'] ?? 'Unknown';
            final bio = userData['bio'] ?? '';
            final profileImageUrl = userData['profileImageUrl'];
            final xp = userData['xp'] ?? 0;
            final level = (xp ~/ 1000);

            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
            final followers = List<String>.from(userData['followers'] ?? []);
            final following = List<String>.from(userData['following'] ?? []);

            final followersCount = userData['followersCount'] ?? followers.length;
            final followingCount = userData['followingCount'] ?? following.length;

            final isFollowing =
                currentUserId != null && followers.contains(currentUserId);

            final location = userData['location']?.toString();
            final locationLat = userData['locationLat']?.toString();
            final locationLon = userData['locationLon']?.toString();
            final website = userData['website']?.toString();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 48),
                      const Spacer(),
                      PopupMenuButton<String>(
                        color: Theme.of(context).colorScheme.surface,
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                        ),
                        onSelected: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$value coming soon'),
                            ),
                          );
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'Report profile',
                            child: Text('Report profile'),
                          ),
                          PopupMenuItem(
                            value: 'Share profile',
                            child: Text('Share profile'),
                          ),
                          PopupMenuItem(
                            value: 'Block user',
                            child: Text(
                              'Block user',
                              style: TextStyle(color: Color(0xFFEB5D4F)),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                        ),
                      ),
                    ],
                  ),

                  OtherProfileHeader(
                    level: level,
                    followingCount: followingCount,
                    followersCount: followersCount,
                    profileImageUrl: profileImageUrl,
                    onFollowingTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => FollowListSheet(
                          title: 'Following',
                          userIds: following,
                        ),
                      );
                    },
                    onFollowersTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => FollowListSheet(
                          title: 'Followers',
                          userIds: followers,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  OtherProfileMeta(
                    username: username,
                    bio: bio.toString(),
                    location: location,
                    locationLat: locationLat,
                    locationLon: locationLon,
                    website: website,
                  ),


                  const SizedBox(height: 22),

                  OtherProfileActions(
                    isFollowing: isFollowing,
                    onFollowTap: () async {
                      if (currentUserId == null) return;

                      final currentUserRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUserId);

                      final otherUserRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId);

                      if (isFollowing) {
                        await currentUserRef.update({
                          'following': FieldValue.arrayRemove([userId]),
                          'followingCount': FieldValue.increment(-1),
                        });

                        await otherUserRef.update({
                          'followers': FieldValue.arrayRemove([currentUserId]),
                          'followersCount': FieldValue.increment(-1),
                        });
                      } else {
                        await currentUserRef.set({
                          'following': FieldValue.arrayUnion([userId]),
                          'followingCount': FieldValue.increment(1),
                        }, SetOptions(merge: true));

                        await otherUserRef.set({
                          'followers': FieldValue.arrayUnion([currentUserId]),
                          'followersCount': FieldValue.increment(1),
                        }, SetOptions(merge: true));
                      }
                    },
                    onMessageTap: () async {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) return;

                      try {
                        final chatService = ChatService();

                        final chatID = await chatService.createDirectChat(
                          currentUserID: currentUser.uid,
                          otherUserID: userId,
                        );

                        if (!context.mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupChatPage(
                              chatID: chatID,
                              chatName: username,
                              isGroup: false,
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not open chat: $e')),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Text(
                        'POSTED SIDEQUESTS',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),

                  const SizedBox(height: 14),

                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('userId', isEqualTo: userId)
                        .snapshots(),
                    builder: (context, postsSnapshot) {
                      if (!postsSnapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                            color: Color(0xFFEB5D4F),
                          ),
                        );
                      }

                      final docs = postsSnapshot.data!.docs;

                      if (docs.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Text(
                            'No posts yet.',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)),
                          ),
                        );
                      }

                      return OtherProfilePostGrid(docs: docs);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
