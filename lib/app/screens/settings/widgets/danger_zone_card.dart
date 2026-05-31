import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_theme.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../../login/login_page.dart';

class DangerZoneCard extends StatefulWidget {
  const DangerZoneCard({super.key});

  @override
  State<DangerZoneCard> createState() {
    return _DangerZoneCardState();
  }
}

class _DangerZoneCardState extends State<DangerZoneCard> {
  bool _isDeleting = false;
  bool _isLoggingOut = false;

  Future<void> _logout(BuildContext context) async {
    if (_isLoggingOut || _isDeleting) {
      return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) {
        return;
      }

      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ),
            (route) => false,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      setState(() {
        _isLoggingOut = false;
      });

      _showSnackBar(
        context: context,
        message: AppLocalizations.of(context)!.logoutFailed,
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    if (_isDeleting || _isLoggingOut) {
      return;
    }

    final password = await _showPasswordDialog(context);

    if (password == null || password.isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!context.mounted) {
        return;
      }

      _showSnackBar(
        context: context,
        message: AppLocalizations.of(context)!.noUserLoggedIn,
      );
      return;
    }

    final email = user.email;

    if (email == null || email.isEmpty) {
      if (!context.mounted) {
        return;
      }

      _showSnackBar(
        context: context,
        message: AppLocalizations.of(context)!.accountCannotBeDeletedWithPassword,
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isDeleting = true;
      });
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await _deleteUserData(user.uid);

      await user.delete();

      if (!context.mounted) {
        return;
      }

      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) {
        return;
      }

      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }

      String message = AppLocalizations.of(context)!.accountCouldNotBeDeleted;

      if (error.code == 'wrong-password') {
        message = AppLocalizations.of(context)!.wrongPassword(error.code);
      } else if (error.code == 'invalid-credential') {
        message = AppLocalizations.of(context)!.invalidCredential(error.code);
      } else if (error.code == 'requires-recent-login') {
        message = AppLocalizations.of(context)!.requiresRecentLogin;
      } else if (error.code == 'user-mismatch') {
        message = AppLocalizations.of(context)!.userMismatch;
      } else if (error.code == 'user-not-found') {
        message = AppLocalizations.of(context)!.userNotFound;
      } else {
        message = AppLocalizations.of(context)!.accountCouldNotBeDeletedWithCode(error.code);
      }

      _showSnackBar(
        context: context,
        message: message,
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }

      _showSnackBar(
        context: context,
        message: AppLocalizations.of(context)!.accountCouldNotBeDeleted,
      );
    }
  }

  Future<void> _deleteUserData(String userID) async {
    final firestore = FirebaseFirestore.instance;

    final userDoc = firestore.collection('users').doc(userID);
    await userDoc.delete();

    final chatsSnapshot = await firestore
        .collection('chats')
        .where('memberIDs', arrayContains: userID)
        .get();

    for (final chatDoc in chatsSnapshot.docs) {
      final messagesSnapshot = await chatDoc.reference
          .collection('messages')
          .get();

      final batch = firestore.batch();

      for (final messageDoc in messagesSnapshot.docs) {
        batch.delete(messageDoc.reference);
      }

      batch.delete(chatDoc.reference);

      await batch.commit();
    }
  }

  Future<String?> _showPasswordDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const _DeleteAccountPasswordDialog();
      },
    );
  }

  void _showSnackBar({
    required BuildContext context,
    required String message,
  }) {
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
    final bool isBusy = _isDeleting || _isLoggingOut;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFF8D84).withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF8D84).withOpacity(0.10),
                  border: Border.all(
                    color: const Color(0xFFFF8D84).withOpacity(0.18),
                  ),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Color(0xFFFF8D84),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dangerZone,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.dangerZoneSubtitle,
                      style: TextStyle(
                        color: Color(0xFF8A8F98),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isDeleting) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFFF8D84),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.deletingAccount,
                  style: TextStyle(
                    color: Color(0xFFFF8D84),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DangerButton(
                  label: _isLoggingOut ? l10n.loggingOut : l10n.logOut,
                  icon: Icons.logout_rounded,
                  filled: false,
                  isDisabled: isBusy,
                  onTap: () {
                    _logout(context);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DangerButton(
                  label: _isDeleting ? l10n.deleting : l10n.deleteAccountButton,
                  icon: Icons.delete_rounded,
                  filled: true,
                  isDisabled: isBusy,
                  onTap: () {
                    _deleteAccount(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeleteAccountPasswordDialog extends StatefulWidget {
  const _DeleteAccountPasswordDialog();

  @override
  State<_DeleteAccountPasswordDialog> createState() {
    return _DeleteAccountPasswordDialogState();
  }
}

class _DeleteAccountPasswordDialogState
    extends State<_DeleteAccountPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _cancel() {
    Navigator.of(context).pop(null);
  }

  void _confirmDelete() {
    Navigator.of(context).pop(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: const Color(0xFF10131B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      title: Text(
        l10n.deleteAccountTitle,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w900,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.deleteAccountText,
              style: TextStyle(
                color: Color(0xFFB8BEC8),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.none,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: l10n.passwordHint,
                hintStyle: TextStyle(
                  color: Color(0xFF747D8C),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF252B38),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF252B38),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF8D84),
                  ),
                ),
              ),
              onSubmitted: (_) {
                _confirmDelete();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Text(
            l10n.cancel.toUpperCase(),
            style: TextStyle(
              color: Color(0xFF8A8F98),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        TextButton(
          onPressed: _confirmDelete,
          child: Text(
            l10n.deleteAccountButton,
            style: TextStyle(
              color: Color(0xFFFF8D84),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final bool isDisabled;
  final VoidCallback onTap;

  const _DangerButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFFFF8D84);
    final Color disabledColor = const Color(0xFF4A4A4A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: filled
                ? isDisabled
                ? disabledColor
                : activeColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isDisabled
                  ? disabledColor
                  : activeColor.withOpacity(0.35),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: filled
                    ? Colors.black
                    : isDisabled
                    ? disabledColor
                    : activeColor,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: filled
                      ? Colors.black
                      : isDisabled
                      ? disabledColor
                      : activeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}