import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../screens/own_profile/own_profile_page.dart';
import '../../screens/other_profile/other_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowListSheet extends StatelessWidget {
  final String title;
  final List<String> userIds;

  const FollowListSheet({
    super.key,
    required this.title,
    required this.userIds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF101216),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: userIds.isEmpty
                ? const Center(
              child: Text(
                'No users yet.',
                style: TextStyle(color: Colors.white54),
              ),
            )
                : ListView.builder(
              itemCount: userIds.length,
              itemBuilder: (context, index) {
                final userId = userIds[index];

                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.data();

                    if (data == null) {
                      return const SizedBox.shrink();
                    }

                    final username = data['username'] ?? 'Unknown';
                    final profileImageUrl =
                    data['profileImageUrl']?.toString();

                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);

                        final currentUserId =
                            FirebaseAuth.instance.currentUser?.uid;

                        if (userId == currentUserId) {
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
                                userId: userId,
                              ),
                            ),
                          );
                        }
                      },
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF1B2026),
                        backgroundImage: profileImageUrl != null &&
                            profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                        child: profileImageUrl == null ||
                            profileImageUrl.isEmpty
                            ? const Icon(
                          Icons.person_rounded,
                          color: Colors.white54,
                        )
                            : null,
                      ),
                      title: Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}