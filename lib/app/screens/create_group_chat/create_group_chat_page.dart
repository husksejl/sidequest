import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../../shared/services/chat_service.dart';
import '../group_chat/group_chat_page.dart';

class CreateGroupChatPage extends StatefulWidget {
  const CreateGroupChatPage({super.key});

  @override
  State<CreateGroupChatPage> createState() {
    return _CreateGroupChatPageState();
  }
}

class _CreateGroupChatPageState extends State<CreateGroupChatPage> {
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<_SelectableUser> _selectedUsers = [];

  String _searchText = '';
  bool _isCreating = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<_SelectableUser>> _searchUsers(String currentUserID) async {
    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
    }

    final snapshot = await _firestore.collection('users').get();

    final users = snapshot.docs.map((doc) {
      final data = doc.data();

      return _SelectableUser(
        id: doc.id,
        username: data['username'] ?? AppLocalizations.of(context)!.unknownUser,
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

  bool _isSelected(_SelectableUser user) {
    return _selectedUsers.any((selectedUser) {
      return selectedUser.id == user.id;
    });
  }

  void _toggleUser(_SelectableUser user) {
    setState(() {
      if (_isSelected(user)) {
        _selectedUsers.removeWhere((selectedUser) {
          return selectedUser.id == user.id;
        });
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  Future<void> _createGroupChat() async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _showError(l10n.pleaseLogIn);
      return;
    }

    final groupName = _groupNameController.text.trim();

    if (groupName.isEmpty) {
      _showError(l10n.pleaseEnterGroupName);
      return;
    }

    if (_selectedUsers.isEmpty) {
      _showError(l10n.pleaseSelectAtLeastOneUser);
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final memberIDs = [
        currentUser.uid,
        ..._selectedUsers.map((user) {
          return user.id;
        }),
      ];

      final chatID = await _chatService.createGroupChat(
        groupName: groupName,
        memberIDs: memberIDs,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return GroupChatPage(
              chatID: chatID,
              chatName: groupName,
              isGroup: true,
            );
          },
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError(l10n.groupChatCouldNotBeCreated);
    }

    if (mounted) {
      setState(() {
        _isCreating = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8B1E2D),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Text(
              l10n.pleaseLogIn,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                children: [
                  buildGroupNameField(),
                  const SizedBox(height: 18),
                  buildSelectedUsers(),
                  const SizedBox(height: 18),
                  buildSearchBar(),
                  const SizedBox(height: 18),
                  FutureBuilder<List<_SelectableUser>>(
                    future: _searchUsers(currentUser.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text(
                              l10n.usersCouldNotBeLoaded,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }

                      if (_searchText.trim().isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text(
                              l10n.searchForUsersToAddThem,
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
                        return Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text(
                              l10n.noUsersFound,
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
                            _UserSelectCard(
                              user: users[i],
                              isSelected: _isSelected(users[i]),
                              onTap: () {
                                _toggleUser(users[i]);
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF00E5FF),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.createGroup,
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.startNewGroupChat,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF102326),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00E5FF).withOpacity(0.6),
              ),
            ),
            child: Icon(
              Icons.groups_rounded,
              color: Color(0xFF00E5FF),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGroupNameField() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.groupName,
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF15292C),
            ),
          ),
          child: TextField(
            controller: _groupNameController,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: l10n.groupNameHint,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSelectedUsers() {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedUsers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF101010),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          l10n.noUsersSelectedYet,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (int i = 0; i < _selectedUsers.length; i++)
          GestureDetector(
            onTap: () {
              _toggleUser(_selectedUsers[i]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF102326),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: const Color(0xFF00E5FF).withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedUsers[i].username,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.close_rounded,
                    color: Color(0xFF00E5FF),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget buildSearchBar() {
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
          Icon(
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: l10n.searchUsers,
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
              child: Icon(
                Icons.close_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCreateButton() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      color: const Color(0xFF050608),
      child: GestureDetector(
        onTap: _isCreating ? null : _createGroupChat,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _isCreating
                ? const Color(0xFF4A4A4A)
                : const Color(0xFFFF7A66),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: _isCreating
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
                : Text(
              l10n.createGroupChat,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectableUser {
  final String id;
  final String username;
  final String email;

  const _SelectableUser({
    required this.id,
    required this.username,
    required this.email,
  });
}

class _UserSelectCard extends StatelessWidget {
  final _SelectableUser user;
  final bool isSelected;
  final VoidCallback onTap;

  const _UserSelectCard({
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subtitle = user.email.isEmpty ? l10n.addToGroup : user.email;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00E5FF)
                : Colors.transparent,
          ),
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
              child: Icon(
                isSelected
                    ? Icons.check_rounded
                    : Icons.person_add_alt_1_rounded,
                color: Theme.of(context).colorScheme.onSurface,
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: isSelected
                  ? const Color(0xFF00E5FF)
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}