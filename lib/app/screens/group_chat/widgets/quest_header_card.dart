import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../../../shared/models/challenge_invite.dart';
import '../../../shared/services/challenge_invite_service.dart';

class QuestHeaderCard extends StatefulWidget {
  final String chatID;

  const QuestHeaderCard({
    super.key,
    required this.chatID,
  });

  @override
  State<QuestHeaderCard> createState() {
    return _QuestHeaderCardState();
  }
}

class _QuestHeaderCardState extends State<QuestHeaderCard> {
  final ChallengeInviteService _challengeInviteService =
  ChallengeInviteService();

  bool _isLoading = false;

  Future<void> _acceptInvite(ChallengeInvite invite) async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _challengeInviteService.acceptInvite(invite.id);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError(AppLocalizations.of(context)!.inviteCouldNotBeAccepted);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _declineInvite(ChallengeInvite invite) async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _challengeInviteService.declineInvite(invite.id);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError(AppLocalizations.of(context)!.inviteCouldNotBeDeclined);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _completeInvite(ChallengeInvite invite) async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _challengeInviteService.completeInvite(invite.id);

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError(AppLocalizations.of(context)!.inviteCouldNotBeCompleted);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
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
    return StreamBuilder<ChallengeInvite?>(
      stream: _challengeInviteService.watchActiveInviteForChat(widget.chatID),
      builder: (context, snapshot) {
        final invite = snapshot.data;

        if (invite == null) {
          return const SizedBox.shrink();
        }

        if (invite.status == 'pending') {
          return _PendingInviteCard(
            invite: invite,
            isLoading: _isLoading,
            onAccept: () {
              _acceptInvite(invite);
            },
            onDecline: () {
              _declineInvite(invite);
            },
          );
        }

        if (invite.status == 'accepted') {
          return _AcceptedInviteCard(
            invite: invite,
            isLoading: _isLoading,
            onComplete: () {
              _completeInvite(invite);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _PendingInviteCard extends StatelessWidget {
  final ChallengeInvite invite;
  final bool isLoading;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _PendingInviteCard({
    required this.invite,
    required this.isLoading,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final title = invite.challengeTitle.isEmpty
        ? AppLocalizations.of(context)!.newSideQuestInvitation
        : invite.challengeTitle;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF102326),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF0B3D40),
        ),
      ),
      child: Row(
        children: [
          const _HeaderIcon(
            icon: Icons.mail_rounded,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.sideQuestInvite,
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _SmallActionButton(
                      label: AppLocalizations.of(context)!.accept,
                      isFilled: true,
                      isLoading: isLoading,
                      onTap: onAccept,
                    ),
                    const SizedBox(width: 8),
                    _SmallActionButton(
                      label: AppLocalizations.of(context)!.decline,
                      isFilled: false,
                      isLoading: isLoading,
                      onTap: onDecline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AcceptedInviteCard extends StatelessWidget {
  final ChallengeInvite invite;
  final bool isLoading;
  final VoidCallback onComplete;

  const _AcceptedInviteCard({
    required this.invite,
    required this.isLoading,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final title = invite.challengeTitle.isEmpty
        ? 'Active SideQuest'
        : invite.challengeTitle;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF102326),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF0B3D40),
        ),
      ),
      child: Row(
        children: [
          const _HeaderIcon(
            icon: Icons.public,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACTIVE SIDEQUEST',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _CompleteButton(
            isLoading: isLoading,
            onTap: onComplete,
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;

  const _HeaderIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF00E5FF),
        size: 23,
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final String label;
  final bool isFilled;
  final bool isLoading;
  final VoidCallback onTap;

  const _SmallActionButton({
    required this.label,
    required this.isFilled,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isFilled
        ? const Color(0xFFFF7A66)
        : const Color(0xFF00E5FF);

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isFilled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: color.withValues(alpha: 0.75),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isFilled ? Colors.black : color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _CompleteButton({
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7A66),
          borderRadius: BorderRadius.circular(999),
        ),
        child: isLoading
            ? const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black,
          ),
        )
            : const Text(
          'COMPLETE',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}