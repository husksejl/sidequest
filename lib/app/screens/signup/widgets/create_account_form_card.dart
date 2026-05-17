import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import '../../../shared/services/auth_service.dart';
import '../../home_screen/home_screen.dart';
import '../../login/login_page.dart';
import 'create_account_text_field.dart';
import 'profile_photo_picker.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateAccountFormCard extends StatefulWidget {
  const CreateAccountFormCard({super.key});

  @override
  State<CreateAccountFormCard> createState() => _CreateAccountFormCardState();
}

class _CreateAccountFormCardState extends State<CreateAccountFormCard> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final AuthService _authService = AuthService();

  bool _acceptedTerms = true;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  String? _errorMessage;

  String? _profileImagePath;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String?> _uploadProfileImage(String uid) async {
    if (_profileImagePath == null) return null;

    final file = File(_profileImagePath!);

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('$uid.jpg');

    await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return ref.getDownloadURL();
  }

  Future<void> _createAccount() async {
    final l10n = AppLocalizations.of(context)!;

    FocusScope.of(context).unfocus();

    final String fullName = _fullNameController.text.trim();
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    final String? validationError = _validateInput(
      l10n: l10n,
      fullName: fullName,
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (validationError != null) {
      setState(() {
        _errorMessage = validationError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.register(
        fullName: fullName,
        username: username,
        email: email,
        password: password,
      );

      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        final profileImageUrl = await _uploadProfileImage(uid);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({
          'profileImageUrl': profileImageUrl,
          'fullName': fullName,
          'firstName': fullName.split(' ').first,
          'xp': 0,
        }, SetOptions(merge: true));
      }

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        _errorMessage = _getReadableFirebaseError(error.code);
      });
    } catch (error) {
      setState(() {
        _errorMessage = l10n.somethingWentWrong;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateInput({
    required AppLocalizations l10n,
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (fullName.isEmpty) {
      return l10n.enterFullName;
    }

    if (username.isEmpty) {
      return l10n.chooseUsername;
    }

    if (username.length < 3) {
      return l10n.usernameTooShort;
    }

    if (email.isEmpty) {
      return l10n.enterEmail;
    }

    if (!email.contains('@') || !email.contains('.')) {
      return AppLocalizations.of(context)!.enterValidEmail;
    }

    if (password.isEmpty) {
      return l10n.enterPassword;
    }

    if (password.length < 6) {
      return l10n.passwordTooShort;
    }

    if (password != confirmPassword) {
      return l10n.passwordsDoNotMatch;
    }

    if (!_acceptedTerms) {
      return l10n.acceptTerms;
    }

    return null;
  }

  String _getReadableFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return AppLocalizations.of(context)!.emailAlreadyInUse;
      case 'invalid-email':
        return AppLocalizations.of(context)!.enterValidEmail;
      case 'weak-password':
        return AppLocalizations.of(context)!.weakPassword;
      case 'operation-not-allowed':
        return AppLocalizations.of(context)!.emailSignupDisabled;
      case 'network-request-failed':
        return AppLocalizations.of(context)!.networkError;
      default:
        return AppLocalizations.of(context)!.signupFailed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF111821),
            Color(0xFF090C10),
            Color(0xFF0A1215),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF18D7FF).withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          ProfilePhotoPicker(
            onImageSelected: (path) {
              _profileImagePath = path;
            },
          ),
          const SizedBox(height: 26),
          CreateAccountTextField(
            controller: _fullNameController,
            label: l10n.fullName,
            hintText: 'Alex Explorer',
            trailingIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          CreateAccountTextField(
            controller: _usernameController,
            label: l10n.username,
            hintText: 'alexexplores',
            trailingIcon: Icons.alternate_email_rounded,
          ),
          const SizedBox(height: 16),
          CreateAccountTextField(
            controller: _emailController,
            label: l10n.email,
            hintText: 'alex@example.com',
            trailingIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CreateAccountTextField(
            controller: _passwordController,
            label: l10n.password,
            hintText: '••••••••••••',
            trailingIcon: Icons.lock_outline_rounded,
            obscureText: !_showPassword,
            extraTrailing: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white70,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 16),
          CreateAccountTextField(
            controller: _confirmPasswordController,
            label: l10n.confirmPassword,
            hintText: '••••••••••••',
            trailingIcon: Icons.lock_outline_rounded,
            obscureText: !_showConfirmPassword,
            textInputAction: TextInputAction.done,
            extraTrailing: GestureDetector(
              onTap: () {
                setState(() {
                  _showConfirmPassword = !_showConfirmPassword;
                });
              },
              child: Icon(
                _showConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white70,
                size: 22,
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 18),
            _SignupErrorBox(message: _errorMessage!),
          ],
          const SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _isLoading
                ? null
                : () {
              setState(() {
                _acceptedTerms = !_acceptedTerms;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _acceptedTerms
                          ? const Color(0xFF18D7FF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _acceptedTerms
                            ? const Color(0xFF18D7FF)
                            : Colors.white24,
                      ),
                    ),
                    child: _acceptedTerms
                        ? const Icon(
                      Icons.check_rounded,
                      color: Colors.black,
                      size: 20,
                    )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: l10n.agreeToThe,
                        children: [
                          TextSpan(
                            text: l10n.termsPrivacyPolicy,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        color: Color(0xFFC1C6CF),
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: _acceptedTerms
                      ? const [
                    Color(0xFF18D7FF),
                    Color(0xFFFF9B8F),
                  ]
                      : [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.08),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8D84).withOpacity(0.18),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed:
                _acceptedTerms && !_isLoading ? _createAccount : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.black,
                  ),
                )
                    : Text(
                  l10n.createAccountButton,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _isLoading
                ? null
                : () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: Text.rich(
              TextSpan(
                text: l10n.alreadyHaveAccount,
                children: [
                  TextSpan(
                    text: l10n.logInCaps,
                    style: const TextStyle(
                      color: Color(0xFF18D7FF),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF9AA0AA),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignupErrorBox extends StatelessWidget {
  final String message;

  const _SignupErrorBox({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4D6D).withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFF4D6D).withOpacity(0.42),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFFB3C0),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFFFC2CC),
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}