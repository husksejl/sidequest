import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/custom_bottom_nav.dart';
import '../../shared/widgets/top_bar.dart';
import 'models/group_challenge.dart';
import '../../shared/models/app_chat.dart';

class GroupChallengeDiscoveryPage extends StatefulWidget {
  const GroupChallengeDiscoveryPage({super.key});

  @override
  State<GroupChallengeDiscoveryPage> createState() =>
      _GroupChallengeDiscoveryPageState();
}

class _GroupChallengeDiscoveryPageState
    extends State<GroupChallengeDiscoveryPage> {
  String selectedFilter = 'All';

  Widget _buildFilterChips() {
    final filters = ['All', 'Open', 'Invited', 'Active', 'Completed'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final selected = selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF00D7E8).withOpacity(0.14)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF00D7E8)
                        : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF00D7E8)
                        : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.54),
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  void _openInviteSheet(BuildContext context, GroupChallenge challenge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _InvitePeopleSheet(challenge: challenge),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppTopBar(),
              const SizedBox(height: 22),

              const SizedBox(height: 6),

              Text(
                'Weekly Group SideQuests',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Invite friends, accept together and complete the challenge as a team.',
                style: TextStyle(
                  color: colors.onSurface.withOpacity(0.42),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 18),

              _buildFilterChips(),

              const SizedBox(height: 18),

              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('group_sidequests')
                      .orderBy(FieldPath.documentId)
                      .limit(7)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const _ErrorState(
                        message: 'Group SideQuests could not be loaded.',
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: colors.primary),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const _EmptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data = doc.data();

                        final challenge = GroupChallenge(
                          id: doc.id,
                          title: data['title'] ?? '',
                          subtitle: '',
                          description: data['description'] ?? '',
                          imagePath: '',
                          members: 0,
                          quests: 0,
                          category: data['category'] ?? 'Group',
                          level: '',
                          reward: '',
                          time: '',
                          questIdeas: const [],
                        );

                        return _GroupQuestCardWithRunState(
                          challenge: challenge,
                          selectedFilter: selectedFilter,
                          onInvite: () => _openInviteSheet(context, challenge),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupQuestCardWithRunState extends StatelessWidget {
  final GroupChallenge challenge;
  final VoidCallback onInvite;
  final String selectedFilter;

  const _GroupQuestCardWithRunState({
    required this.challenge,
    required this.onInvite,
    required this.selectedFilter,
  });


  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return _GroupQuestCard(
        challenge: challenge,
        onInvite: onInvite,
        invitedUsers: const [],
        acceptedUserIds: const [],
        hasRun: false,
        isActive: false,
        successfulCount: 0,
        runId: null,
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('group_challenge_runs')
          .where('templateId', isEqualTo: challenge.id)
          .where('participantIds', arrayContains: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          if (selectedFilter != 'All' && selectedFilter != 'Open') {
            return const SizedBox.shrink();
          }
          return _GroupQuestCard(
            challenge: challenge,
            onInvite: onInvite,
            invitedUsers: const [],
            acceptedUserIds: const [],
            hasRun: false,
            isActive: false,
            successfulCount: 0,
            runId: null,
          );
        }

        final allRuns = snapshot.data!.docs;

        final successfulCount = allRuns.where((doc) {
          final data = doc.data();

          final status = data['status'];
          final completedVotes = data['completedVotes'] ?? 0;
          final failedVotes = data['failedVotes'] ?? 0;

          return status == 'closed_successful' ||
              (status == 'completed' && completedVotes > failedVotes);
        }).length;

        final activeRuns = allRuns.where((doc) {
          final data = doc.data();
          final status = data['status'];
          final expiresAt = data['expiresAt'];

          final isExpired = expiresAt is Timestamp &&
              expiresAt.toDate().isBefore(DateTime.now());

          return status != 'completed' &&
              status != 'closed_successful' &&
              status != 'expired' &&
              !isExpired;
        }).toList();

        if (activeRuns.isEmpty) {
          if (selectedFilter != 'All' &&
              selectedFilter != 'Open' &&
              selectedFilter != 'Completed') {
            return const SizedBox.shrink();
          }
          return _GroupQuestCard(
            challenge: challenge,
            onInvite: onInvite,
            invitedUsers: const [],
            acceptedUserIds: const [],
            hasRun: false,
            isActive: false,
            successfulCount: successfulCount,
            runId: null,
          );
        }

        final runData = activeRuns.first.data();

        final invitedUserIds = List<String>.from(
          (runData['invitedUserIds'] ?? []).map((e) => e.toString()),
        );

        final acceptedUserIds = List<String>.from(
          (runData['acceptedUserIds'] ?? []).map((e) => e.toString()),
        );

        final isActive = invitedUserIds.isNotEmpty &&
            invitedUserIds.every((id) => acceptedUserIds.contains(id));

        final matchesFilter =
            selectedFilter == 'All' ||
                selectedFilter == 'Invited' ||
                (selectedFilter == 'Active' && isActive);

        if (!matchesFilter) {
          return const SizedBox.shrink();
        }

        return FutureBuilder<List<_InvitedUserInfo>>(
          future: _loadInvitedUsers(invitedUserIds),
          builder: (context, userSnapshot) {
            return _GroupQuestCard(
              challenge: challenge,
              onInvite: onInvite,
              invitedUsers: userSnapshot.data ?? const [],
              acceptedUserIds: acceptedUserIds,
              hasRun: true,
              isActive: isActive,
              successfulCount: successfulCount,
              runId: activeRuns.first.id,
            );
          },
        );
      },
    );
  }

  Future<List<_InvitedUserInfo>> _loadInvitedUsers(List<String> userIds) async {
    final List<_InvitedUserInfo> users = [];

    for (final userId in userIds) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final data = doc.data();

      users.add(
        _InvitedUserInfo(
          id: userId,
          username: data?['username']?.toString() ?? 'Unknown',
        ),
      );
    }

    return users;
  }
}

class _UserStatusChip extends StatelessWidget {
  final String username;
  final bool isAccepted;

  const _UserStatusChip({
    required this.username,
    required this.isAccepted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: isAccepted
            ? colors.primary.withOpacity(0.15)
            : colors.onSurface.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isAccepted
              ? colors.primary
              : colors.onSurface.withOpacity(0.14),
        ),
      ),
      child: Text(
        username,
        style: TextStyle(
          color: isAccepted
              ? colors.primary
              : colors.onSurface.withOpacity(0.42),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InvitedUserInfo {
  final String id;
  final String username;

  const _InvitedUserInfo({
    required this.id,
    required this.username,
  });
}

class _GroupQuestCard extends StatelessWidget {
  final GroupChallenge challenge;
  final VoidCallback onInvite;
  final List<_InvitedUserInfo> invitedUsers;
  final List<String> acceptedUserIds;
  final bool hasRun;
  final bool isActive;
  final int successfulCount;
  final String? runId;

  const _GroupQuestCard({
    required this.challenge,
    required this.onInvite,
    required this.invitedUsers,
    required this.acceptedUserIds,
    required this.hasRun,
    this.isActive = false,
    this.successfulCount = 0,
    this.runId,
  });

  Future<void> _deleteGroupRequest() async {
    if (runId == null) return;

    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    final invites = await firestore
        .collection('challengeInvites')
        .where('runId', isEqualTo: runId)
        .get();

    for (final invite in invites.docs) {
      batch.delete(invite.reference);
    }

    batch.delete(
      firestore.collection('group_challenge_runs').doc(runId),
    );

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Stack(
      children: [
        Container(
    padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : colors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isActive
              ? colors.secondary
              : hasRun
              ? colors.primary
              : colors.onSurface.withOpacity(isLight ? 0.08 : 0.10),
          width: isActive ? 6 : hasRun ? 2 : 1,
        ),
        boxShadow: [
          if (isLight)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isActive) ...[
            Text(
              'ACTIVE GROUP SIDEQUEST',
              style: TextStyle(
                color: colors.secondary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            children: [
              _CategoryBadge(category: challenge.category),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.secondary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '200 XP',
                  style: TextStyle(
                    color: colors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            challenge.title,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            challenge.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onSurface.withOpacity(0.58),
              fontSize: 13,
              height: 1.42,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),


          const SizedBox(height: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (invitedUsers.isEmpty)
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.groups_rounded,
                        color: colors.primary,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Complete together with friends',
                        style: TextStyle(
                          color: colors.onSurface.withOpacity(0.55),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final user in invitedUsers)
                      _UserStatusChip(
                        username: user.username,
                        isAccepted: acceptedUserIds.contains(user.id),
                      ),
                  ],
                ),

              const SizedBox(height: 14),

              Row(
                children: [
                  GestureDetector(
                    onTap: onInvite,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: hasRun ? Colors.transparent : colors.secondary,
                        borderRadius: BorderRadius.circular(999),
                        border: hasRun
                            ? Border.all(
                          color: colors.secondary,
                          width: 1.5,
                        )
                            : null,
                      ),
                      child: Text(
                        hasRun ? 'Invite more people' : 'Invite',
                        style: TextStyle(
                          color: hasRun
                              ? colors.secondary
                              : Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  if (hasRun && runId != null) ...[
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _deleteGroupRequest,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: const Color(0xFFEB5D4F),
                            width: 1.5,
                          ),
                        ),
                        child: const Text(
                          'Cancel request',
                          style: TextStyle(
                            color: Color(0xFFEB5D4F),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    ),

    if (successfulCount > 0)
    Positioned(
    right: 14,
    bottom: 14,
    child: Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: colors.secondary.withOpacity(0.18),
    border: Border.all(
    color: colors.secondary,
    width: 2,
    ),
    ),
    child: Center(
    child: Text(
    '$successfulCount',
    style: TextStyle(
    color: colors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w900,
    ),
    ),
    ),
    ),
    ),
    ],
    );
  }
}



class _InvitePeopleSheet extends StatefulWidget {
  final GroupChallenge challenge;

  const _InvitePeopleSheet({
    required this.challenge,
  });

  @override
  State<_InvitePeopleSheet> createState() => _InvitePeopleSheetState();
}

class _InvitePeopleSheetState extends State<_InvitePeopleSheet> {
  final Set<String> selectedUserIds = {};
  final Set<String> selectedChatIds = {};
  String? selectedSourceChatId;
  String? selectedSourceChatName;
  bool isSending = false;
  String searchQuery = '';

  void _toggleUsers(List<String> userIds) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final idsToAdd = userIds
        .where((id) => id != currentUserId)
        .where((id) => !selectedUserIds.contains(id))
        .toList();

    if (selectedUserIds.length + idsToAdd.length > 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can invite up to 6 people total.'),
        ),
      );
      return;
    }

    setState(() {
      selectedUserIds.addAll(idsToAdd);
    });
  }

  Future<void> _sendInvites() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || selectedUserIds.isEmpty) return;

    setState(() => isSending = true);

    final firestore = FirebaseFirestore.instance;

    final currentUserDoc =
    await firestore.collection('users').doc(currentUser.uid).get();

    final fromUsername =
        currentUserDoc.data()?['username']?.toString() ?? 'Unknown user';

    final existingRunSnapshot = await firestore
        .collection('group_challenge_runs')
        .where('templateId', isEqualTo: widget.challenge.id)
        .where('creatorId', isEqualTo: currentUser.uid)
        .limit(1)
        .get();

    late final DocumentReference<Map<String, dynamic>> runRef;
    List<String> alreadyInvitedUserIds = [];

    final reusableRunDocs = existingRunSnapshot.docs.where((doc) {
      final data = doc.data();
      final status = data['status'];
      final expiresAt = data['expiresAt'];

      final isExpired = expiresAt is Timestamp &&
          expiresAt.toDate().isBefore(DateTime.now());

      return status != 'completed' && status != 'expired' && !isExpired;
    }).toList();

    if (reusableRunDocs.isNotEmpty) {
      final existingRunDoc = reusableRunDocs.first;
      final existingRunData = existingRunDoc.data();

      runRef = existingRunDoc.reference;

      alreadyInvitedUserIds = List<String>.from(
        (existingRunData['invitedUserIds'] ?? []).map((e) => e.toString()),
      );
    } else {
      runRef = await firestore.collection('group_challenge_runs').add({
        'templateId': widget.challenge.id,
        'title': widget.challenge.title,
        'description': widget.challenge.description,
        'category': widget.challenge.category,
        'creatorId': currentUser.uid,
        'invitedUserIds': [],
        'acceptedUserIds': [currentUser.uid],
        'declinedUserIds': [],
        'participantIds': [currentUser.uid],
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
        'startedAt': null,
        'expiresAt': null,
      });
    }

    final newUserIds = selectedUserIds
        .where((userId) => !alreadyInvitedUserIds.contains(userId))
        .where((userId) => userId != currentUser.uid)
        .toList();

    final totalInvitedAfterSend = {
      ...alreadyInvitedUserIds,
      ...newUserIds,
    }.length;

    if (totalInvitedAfterSend > 6) {
      if (!mounted) return;

      setState(() => isSending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can invite up to 6 people total.'),
        ),
      );

      return;
    }

    if (newUserIds.isEmpty) {
      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('These users are already invited')),
      );
      return;
    }

    await runRef.update({
      'invitedUserIds': FieldValue.arrayUnion(newUserIds),
      'chatIds': FieldValue.arrayUnion(selectedChatIds.toList()),
    });

    for (final userId in newUserIds) {
      await firestore.collection('challengeInvites').add({
        'runId': runRef.id,
        'templateId': widget.challenge.id,
        'fromUserId': currentUser.uid,
        'fromUsername': fromUsername,
        'toUserId': userId,
        'title': widget.challenge.title,
        'description': widget.challenge.description,
        'category': widget.challenge.category,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'respondedAt': null,
      });
    }

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invitation sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SizedBox(
        height: 520,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite friends',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              widget.challenge.title,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.55),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase().trim();
                });
              },
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Search friends...',
                hintStyle: TextStyle(
                  color: colors.onSurface.withOpacity(0.42),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colors.primary,
                ),
                filled: true,
                fillColor: colors.onSurface.withOpacity(0.04),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: colors.onSurface.withOpacity(0.08),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: colors.onSurface.withOpacity(0.08),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: colors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 14),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('memberIDs', arrayContains: currentUser?.uid)
                  .where('type', isEqualTo: 'group')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SizedBox.shrink();
                }

                final chats = snapshot.data!.docs;

                return SizedBox(
                  height: 92,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = AppChat.fromFirestore(chats[index]);
                      final membersWithoutMe = chat.memberIDs
                          .where((id) => id != currentUser?.uid)
                          .toList();

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedChatIds.add(chat.id);
                          });

                          _toggleUsers(membersWithoutMe);
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: colors.primary.withOpacity(0.45),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.groups_rounded,
                                color: colors.primary,
                                size: 22,
                              ),
                              const Spacer(),
                              Text(
                                chat.name.isEmpty ? 'Group chat' : chat.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                '${membersWithoutMe.length} people',
                                style: TextStyle(
                                  color: colors.onSurface.withOpacity(0.45),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 12),


            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    );
                  }

                  final users = snapshot.data!.docs.where((doc) {
                    if (doc.id == currentUser?.uid) return false;

                    final data = doc.data();
                    final username = data['username']?.toString().toLowerCase() ?? '';
                    final email = data['email']?.toString().toLowerCase() ?? '';

                    if (searchQuery.isEmpty) return true;

                    return username.contains(searchQuery) || email.contains(searchQuery);
                  }).toList();

                  if (users.isEmpty) {
                    return Center(
                      child: Text(
                        'No users found.',
                        style: TextStyle(color: colors.onSurface.withOpacity(0.55)),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final data = user.data();
                      final username = data['username']?.toString() ?? 'Unknown user';
                      final email = data['email']?.toString() ?? '';
                      final selected = selectedUserIds.contains(user.id);

                      return _UserInviteTile(
                        username: username,
                        subtitle: email,
                        selected: selected,
                        onTap: () {
                          setState(() {
                            if (selected) {
                              selectedUserIds.remove(user.id);
                            } else {
                              if (selectedUserIds.length >= 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('You can invite up to 6 people.'),
                                  ),
                                );
                                return;
                              }

                              selectedUserIds.add(user.id);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                selectedUserIds.isEmpty || isSending ? null : _sendInvites,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  foregroundColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  isSending ? 'Sending...' : 'Send invitation',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInviteTile extends StatelessWidget {
  final String username;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _UserInviteTile({
    required this.username,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withOpacity(0.14)
              : colors.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? colors.primary : colors.onSurface.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colors.primary.withOpacity(0.14),
              child: Icon(Icons.person_rounded, color: colors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.onSurface.withOpacity(0.45),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? colors.primary : colors.onSurface.withOpacity(0.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: colors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        'No group quests available yet.',
        style: TextStyle(color: colors.onSurface.withOpacity(0.55)),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: colors.secondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}