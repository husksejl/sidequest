import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../../../shared/models/app_chat.dart';
import '../../../shared/models/app_user.dart';
import '../../../shared/services/chat_service.dart';
import '../../../shared/services/user_service.dart';
import '../../create_group_chat/create_group_chat_page.dart';
import '../../group_chat/group_chat_page.dart';
import '../models/message_thread.dart';
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
  final UserService _userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<_UserSearchResult>> _searchUsers(String currentUserID) async {
    final l10n = AppLocalizations.of(context)!;
    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
    }

    final snapshot = await _firestore.collection('users').get();

    final users = snapshot.docs.map((doc) {
      final data = doc.data();

      return _UserSearchResult(
        id: doc.id,
        username: data['username'] ?? l10n.unknownUser,
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
    final l10n = AppLocalizations.of(context)!;

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
              isGroup: false,
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
          content: Text(l10n.chatCouldNotBeOpened(error.toString())),
          backgroundColor: const Color(0xFF8B1E2D),
        ),
      );
    }
  }

  Future<_ChatDisplayData> _getChatDisplayData({
    required AppChat chat,
    required String currentUserID,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    if (chat.isGroup) {
      return _ChatDisplayData(
        chatName: chat.name.isEmpty ? l10n.groupChat : chat.name,
        isGroup: true,
      );
    }

    final otherUserID = _getOtherUserID(
      chat: chat,
      currentUserID: currentUserID,
    );

    if (otherUserID == null) {
      return _ChatDisplayData(
        chatName: l10n.chat,
        isGroup: false,
      );
    }

    final AppUser? otherUser = await _userService.getUserByID(otherUserID);

    return _ChatDisplayData(
      chatName: otherUser?.username.isNotEmpty == true
          ? otherUser!.username
          : l10n.unknownUser,
      isGroup: false,
    );
  }

  String? _getOtherUserID({
    required AppChat chat,
    required String currentUserID,
  }) {
    final otherUserIDs = chat.memberIDs.where((id) {
      return id != currentUserID;
    }).toList();

    if (otherUserIDs.isEmpty) {
      return null;
    }

    return otherUserIDs.first;
  }

  void _goToCreateGroupChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const CreateGroupChatPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Center(
        child: Text(
          l10n.youNeedToBeLoggedInToSeeChats,
          style: const TextStyle(
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
        buildActionRow(context),
        const SizedBox(height: 14),
        buildSearchBar(context),
        const SizedBox(height: 20),
        if (isSearching)
          FutureBuilder<List<_UserSearchResult>>(
            future: _searchUsers(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      l10n.usersCouldNotBeLoaded,
                      style: const TextStyle(
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
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      l10n.noUsersFound,
                      style: const TextStyle(
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
                      l10n.chatsCouldNotBeLoaded(snapshot.error.toString()),
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
                return chat.lastMessage.trim().isNotEmpty || chat.isGroup;
              }).toList();

              if (chats.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      l10n.noConversationsYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                    _RealChatThreadCard(
                      chat: chats[i],
                      currentUserID: currentUser.uid,
                      getChatDisplayData: _getChatDisplayData,
                      formatTime: _formatTime,
                    ),
                ],
              );
            },
          ),
      ],
    );
  }

  Widget buildActionRow(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _goToCreateGroupChat(context);
            },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A66),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    color: Colors.black,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.newGroup,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(BuildContext context, DateTime dateTime) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return l10n.now;
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

  Widget buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              decoration: InputDecoration(
                hintText: l10n.searchUsersOrConversations,
                hintStyle: const TextStyle(
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

class _RealChatThreadCard extends StatelessWidget {
  final AppChat chat;
  final String currentUserID;
  final Future<_ChatDisplayData> Function({
  required AppChat chat,
  required String currentUserID,
  }) getChatDisplayData;
  final String Function(BuildContext context, DateTime dateTime) formatTime;

  const _RealChatThreadCard({
    required this.chat,
    required this.currentUserID,
    required this.getChatDisplayData,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<_ChatDisplayData>(
      future: getChatDisplayData(
        chat: chat,
        currentUserID: currentUserID,
      ),
      builder: (context, snapshot) {
        final displayData = snapshot.data;

        final chatName = displayData?.chatName ?? l10n.loadingDots;
        final isGroup = displayData?.isGroup ?? chat.isGroup;

        final thread = MessageThread(
          name: chatName,
          preview: chat.lastMessage.isEmpty
              ? isGroup
              ? l10n.groupCreatedSendFirst
              : l10n.noMessagesYet
              : chat.lastMessage,
          time: formatTime(context, chat.updatedAt),
          isGroup: isGroup,
        );

        return MessageThreadCard(
          thread: thread,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return GroupChatPage(
                    chatID: chat.id,
                    chatName: chatName == l10n.loadingDots ? l10n.chat : chatName,
                    isGroup: isGroup,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _ChatDisplayData {
  final String chatName;
  final bool isGroup;

  const _ChatDisplayData({
    required this.chatName,
    required this.isGroup,
  });
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
    final l10n = AppLocalizations.of(context)!;
    final subtitle = user.email.isEmpty ? l10n.startNewChat : user.email;

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
