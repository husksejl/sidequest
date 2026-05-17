import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../other_profile/other_profile_page.dart';
import '../../own_profile/own_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController controller = TextEditingController();
  String searchText = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void openSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF101216),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 18,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
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
                    TextField(
                      controller: controller,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setSheetState(() {
                          searchText = value.trim().toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search users or usernames...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF171A20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: searchText.isEmpty
                          ? const Center(
                        child: Text(
                          'Search for a user.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                          : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF00B2AA),
                              ),
                            );
                          }

                          final users = snapshot.data!.docs.where((doc) {
                            final data = doc.data();
                            final username =
                            (data['username'] ?? '').toString().toLowerCase();

                            return username.contains(searchText);
                          }).toList();

                          if (users.isEmpty) {
                            return const Center(
                              child: Text(
                                'No users found.',
                                style: TextStyle(color: Colors.white54),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final doc = users[index];
                              final data = doc.data();

                              final username = data['username'] ?? 'Unknown';
                              final profileImageUrl =
                              data['profileImageUrl']?.toString();

                              return ListTile(
                                onTap: () {
                                  Navigator.pop(context);

                                  final currentUserId =
                                      FirebaseAuth.instance.currentUser?.uid;

                                  if (doc.id == currentUserId) {
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
                                          userId: doc.id,
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
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openSearch,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white70),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.white70, size: 30),
          ],
        ),
      ),
    );
  }
}