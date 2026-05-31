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