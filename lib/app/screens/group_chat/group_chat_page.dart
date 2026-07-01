import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../../shared/models/app_user.dart';
import '../../shared/models/chat_message.dart' as firestore_message;
import '../../shared/services/message_service.dart';
import '../../shared/services/user_service.dart';
import 'models/chat_message.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/message_input_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../group_challenge_discovery/group_challenge_discovery_page.dart';

class GroupChatPage extends StatefulWidget {
  final String chatID;
  final String chatName;
  final bool isGroup;

  const GroupChatPage({
    super.key,
    required this.chatID,
    required this.chatName,
    this.isGroup = false,
  });

  @override
  State<GroupChatPage> createState() {
    return _GroupChatPageState();
  }
}

class _GroupChatPageState extends State<GroupChatPage> {
  final MessageService _messageService = MessageService();
  final UserService _userService = UserService();

  final Map<String, String> _usernameCache = {};

  bool _isSending = false;

  Future<void> _sendMessage(String text) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.youNeedToBeLoggedInToSendMessages),
          backgroundColor: const Color(0xFF8B1E2D),
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      await _messageService.sendMessage(
        chatID: widget.chatID,
        senderID: currentUser.uid,
        text: text,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.messageCouldNotBeSent(error.toString())),
          backgroundColor: const Color(0xFF8B1E2D),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<String> _getSenderName({
    required String senderID,
    required String currentUserID,
  }) async {
    if (senderID == currentUserID) {
      return AppLocalizations.of(context)!.you;
    }

    if (!widget.isGroup) {
      return widget.chatName;
    }

    if (_usernameCache.containsKey(senderID)) {
      return _usernameCache[senderID]!;
    }

    final AppUser? user = await _userService.getUserByID(senderID);

    final username = user?.username.isNotEmpty == true
        ? user!.username
        : AppLocalizations.of(context)!.unknownUser;

    _usernameCache[senderID] = username;

    return username;
  }

  ChatMessage _toBubbleMessage({
    required firestore_message.ChatMessage message,
    required String senderName,
    required String currentUserID,
  }) {
    final bool isOwnMessage = message.senderID == currentUserID;

    return ChatMessage(
      senderName: senderName,
      text: message.text,
      isOwnMessage: isOwnMessage,
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
              l10n.youNeedToBeLoggedInToViewChat,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
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

            if (widget.isGroup)
              _GroupQuestChatBanner(chatID: widget.chatID),

            Expanded(
              child: StreamBuilder<List<firestore_message.ChatMessage>>(
                stream: _messageService.watchMessages(widget.chatID),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          l10n.messagesCouldNotBeLoaded(snapshot.error.toString()),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00E5FF),
                      ),
                    );
                  }

                  final messages = snapshot.data!;

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noMessagesYetSendFirst,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                    children: [
                      for (int i = 0; i < messages.length; i++)
                        _ChatBubbleWithSenderName(
                          message: messages[i],
                          currentUserID: currentUser.uid,
                          getSenderName: _getSenderName,
                          toBubbleMessage: _toBubbleMessage,
                        ),
                    ],
                  );
                },
              ),
            ),
            MessageInputBar(
              isSending: _isSending,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
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
                  widget.chatName,
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.isGroup ? l10n.groupChat : l10n.directMessage,
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
                color: const Color(0xFF00E5FF).withValues(alpha: 0.6),
              ),
            ),
            child: Icon(
              widget.isGroup ? Icons.groups_rounded : Icons.person,
              color: const Color(0xFF00E5FF),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubbleWithSenderName extends StatelessWidget {
  final firestore_message.ChatMessage message;
  final String currentUserID;

  final Future<String> Function({
  required String senderID,
  required String currentUserID,
  }) getSenderName;

  final ChatMessage Function({
  required firestore_message.ChatMessage message,
  required String senderName,
  required String currentUserID,
  }) toBubbleMessage;

  const _ChatBubbleWithSenderName({
    required this.message,
    required this.currentUserID,
    required this.getSenderName,
    required this.toBubbleMessage,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getSenderName(
        senderID: message.senderID,
        currentUserID: currentUserID,
      ),
      builder: (context, snapshot) {
        final senderName = snapshot.data ?? AppLocalizations.of(context)!.loading;

        return ChatBubble(
          message: toBubbleMessage(
            message: message,
            senderName: senderName,
            currentUserID: currentUserID,
          ),
        );
      },
    );
  }
}




class _GroupQuestChatBanner extends StatelessWidget {
  final String chatID;

  const _GroupQuestChatBanner({
    required this.chatID,
  });

  Future<void> _acceptInvite(String runId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final runRef = firestore.collection('group_challenge_runs').doc(runId);

    final runDoc = await runRef.get();
    final runData = runDoc.data();
    if (runData == null) return;

    final invitedUserIds = List<String>.from(
      (runData['invitedUserIds'] ?? []).map((e) => e.toString()),
    );

    final acceptedUserIds = List<String>.from(
      (runData['acceptedUserIds'] ?? []).map((e) => e.toString()),
    );

    final newAcceptedUserIds = {
      ...acceptedUserIds,
      user.uid,
    }.toList();

    final allAccepted = invitedUserIds.isNotEmpty &&
        invitedUserIds.every((id) => newAcceptedUserIds.contains(id));

    await runRef.update({
      'acceptedUserIds': FieldValue.arrayUnion([user.uid]),
      'participantIds': FieldValue.arrayUnion([user.uid]),
      if (allAccepted) 'status': 'active',
      if (allAccepted) 'startedAt': FieldValue.serverTimestamp(),
      if (allAccepted)
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(hours: 24)),
        ),
    });

    final inviteSnapshot = await firestore
        .collection('challengeInvites')
        .where('runId', isEqualTo: runId)
        .where('toUserId', isEqualTo: user.uid)
        .get();

    for (final invite in inviteSnapshot.docs) {
      await invite.reference.update({
        'status': 'accepted',
        'respondedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('group_challenge_runs')
          .where('chatIds', arrayContains: chatID)
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];

        final activeDocs = docs.where((doc) {
          final data = doc.data();
          final status = data['status'];

          return status == 'waiting' || status == 'active';
        }).toList();

        if (activeDocs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GroupChallengeDiscoveryPage(),
                  ),
                );
              },
              icon: const Icon(Icons.flag_rounded),
              label: const Text('Start a group quest'),
            ),
          );
        }

        final doc = activeDocs.first;
        final data = doc.data();

        final title = data['title'] ?? 'Group Quest';
        final status = data['status'] ?? 'waiting';

        final acceptedUserIds = List<String>.from(
          (data['acceptedUserIds'] ?? []).map((e) => e.toString()),
        );

        final hasAccepted = currentUserId != null &&
            acceptedUserIds.contains(currentUserId);

        final invitedUserIds = List<String>.from(
          (data['invitedUserIds'] ?? []).map((e) => e.toString()),
        );

        final isInvited = currentUserId != null &&
            invitedUserIds.contains(currentUserId);

        return Container(
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: colors.primary.withOpacity(0.55),
            ),
          ),
          child: Row(
            children: [
              Icon(
                status == 'active'
                    ? Icons.local_fire_department_rounded
                    : Icons.hourglass_top_rounded,
                color: colors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status == 'active'
                          ? 'Active group quest'
                          : 'Pending invitation',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (status == 'waiting' && isInvited && !hasAccepted)
                TextButton(
                  onPressed: () => _acceptInvite(doc.id),
                  child: const Text('Accept'),
                ),
            ],
          ),
        );
      },
    );
  }
}