import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/models/app_chat.dart';
import '../../../shared/services/chat_service.dart';
import '../models/message_thread.dart';
import '../../group_chat/group_chat_page.dart';
import '../widgets/messages_thread_card.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({super.key});

  @override
  State<MessagesList> createState() {
    return _MessagesListState();
  }
}

class _MessagesListState extends State<MessagesList> {
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<_UserSearchResult>> _searchUsers(String currentUserID) async {
    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
    }

    final snapshot = await _firestore.collection('users').get();

    final users = snapshot.docs.map((doc) {
      final data = doc.data();

      return _UserSearchResult(
        id: doc.id,
        username: data['username'] ?? 'Unknown User',
        email: data['email'] ?? '',
      );
    }).where((user) {
      final username = user.username.toLowerCase();
      final email = user.email.toLowerCase();

      return user.id != currentUserID &&
          (username.contains(query) || email.contains(query));
    }).toList();

    return users;
  }

  Future<void> _openChatWithUser({
    required BuildContext context,
    required String currentUserID,
    required String otherUserID,
    required String username,
  }) async {
    try {
      final chatID = await _chatService.createDirectChat(
        currentUserID: currentUserID,
        otherUserID: otherUserID,
      );

      if (!context.mounted) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return GroupChatPage(
              chatID: chatID,
              chatName: username,
            );
          },
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chat could not be opened: $error'),
          backgroundColor: const Color(0xFF8B1E2D),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text(
          'You need to be logged in to see your chats.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      );
    }

    final bool isSearching = _searchText.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        buildSearchBar(),
        const SizedBox(height: 20),

        if (isSearching)
          FutureBuilder<List<_UserSearchResult>>(
            future: _searchUsers(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      'Users could not be loaded.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF18D7FF),
                    ),
                  ),
                );
              }

              final users = snapshot.data!;

              if (users.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      'No users found.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  for (int i = 0; i < users.length; i++)
                    _UserSearchCard(
                      user: users[i],
                      onTap: () {
                        _openChatWithUser(
                          context: context,
                          currentUserID: currentUser.uid,
                          otherUserID: users[i].id,
                          username: users[i].username,
                        );
                      },
                    ),
                ],
              );
            },
          )
        else
          StreamBuilder<List<AppChat>>(
            stream: _chatService.watchChatsForUser(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      'Chats could not be loaded.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF18D7FF),
                    ),
                  ),
                );
              }

              final chats = snapshot.data!.where((chat) {
                return chat.lastMessage.trim().isNotEmpty;
              }).toList();

              if (chats.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      'No conversations yet.\nSearch for a user to start chatting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  for (int i = 0; i < chats.length; i++)
                    MessageThreadCard(
                      thread: _chatToThread(
                        chat: chats[i],
                        currentUserID: currentUser.uid,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return GroupChatPage(
                                chatID: chats[i].id,
                                chatName: _getChatName(
                                  chat: chats[i],
                                  currentUserID: currentUser.uid,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  MessageThread _chatToThread({
    required AppChat chat,
    required String currentUserID,
  }) {
    final bool isGroup = chat.type == 'group';

    return MessageThread(
      name: _getChatName(
        chat: chat,
        currentUserID: currentUserID,
      ),
      preview: chat.lastMessage,
      time: _formatTime(chat.updatedAt),
      isGroup: isGroup,
    );
  }

  String _getChatName({
    required AppChat chat,
    required String currentUserID,
  }) {
    if (chat.type == 'group') {
      return 'Group Chat';
    }

    final otherUserIDs = chat.memberIDs.where((id) {
      return id != currentUserID;
    }).toList();

    if (otherUserIDs.isEmpty) {
      return 'Chat';
    }

    return 'Chat Partner';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
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

  Widget buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                hintText: 'Search users or conversations...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchText.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();

                setState(() {
                  _searchText = '';
                });
              },
              child: const Icon(
                Icons.close_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

class _UserSearchResult {
  final String id;
  final String username;
  final String email;

  const _UserSearchResult({
    required this.id,
    required this.username,
    required this.email,
  });
}

class _UserSearchCard extends StatelessWidget {
  final _UserSearchResult user;
  final VoidCallback onTap;

  const _UserSearchCard({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = user.email.isEmpty ? 'Start a new chat' : user.email;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF102326),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00E5FF),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}