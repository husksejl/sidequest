import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/custom_bottom_nav.dart';
import 'widgets/other_profile_post_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtherProfilePage extends StatelessWidget {
  final String userId;

  const OtherProfilePage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
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
              return const Center(
                child: Text(
                  'User not found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final username = userData['username'] ?? 'Unknown';
            final bio = userData['bio'] ?? '';
            final profileImageUrl = userData['profileImageUrl'];
            final xp = userData['xp'] ?? 0;
            final level = (xp / 100).floor() + 1;

            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
            final followers = List<String>.from(userData['followers'] ?? []);
            final following = List<String>.from(userData['following'] ?? []);

            final followersCount = userData['followersCount'] ?? followers.length;
            final followingCount = userData['followingCount'] ?? following.length;

            final isFollowing =
                currentUserId != null && followers.contains(currentUserId);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 48),
                      const Spacer(),
                      PopupMenuButton<String>(
                        color: const Color(0xFF15181D),
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white70,
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
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'LEVEL $level',
                    style: const TextStyle(
                      color: Color(0xFF00B2AA),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _OtherProfileStat(
                        number: '$followingCount',
                        label: 'Following',
                      ),

                      const SizedBox(width: 28),

                      Container(
                        width: 108,
                        height: 108,
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFEB5D4F),
                              Color(0xFF00B2AA),
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF111317),
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : null,
                          child: profileImageUrl == null
                              ? const Icon(
                            Icons.person_rounded,
                            color: Colors.white54,
                            size: 48,
                          )
                              : null,
                        ),
                      ),

                      const SizedBox(width: 28),

                      _OtherProfileStat(
                        number: '$followersCount',
                        label: 'Followers',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    bio.toString().isEmpty
                        ? 'No bio yet.'
                        : bio.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFC8CDD5),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing
                                ? Colors.transparent
                                : const Color(0xFFEB5D4F),

                            foregroundColor: isFollowing
                                ? const Color(0xFFEB5D4F)
                                : Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: const BorderSide(
                              color: Color(0xFFEB5D4F),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: Text(
                            isFollowing ? 'FOLLOWING' : 'FOLLOW',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Message coming soon')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF00B2AA)),
                            foregroundColor: const Color(0xFF00B2AA),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: const Text(
                            'MESSAGE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: const [
                      Text(
                        'POSTED SIDEQUESTS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.grid_on_rounded,
                        color: Color(0xFF00B2AA),
                        size: 18,
                      ),
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
                        return const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Text(
                            'No posts yet.',
                            style: TextStyle(color: Colors.white54),
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

class _OtherProfileStat extends StatelessWidget {
  final String number;
  final String label;

  const _OtherProfileStat({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF8A8F98),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}