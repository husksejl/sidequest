import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_text_field.dart';

class LoginFormCard extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onCreateProfileTap;

  const LoginFormCard({
    super.key,
    required this.onLoginSuccess,
    required this.onCreateProfileTap,
  });

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  final TextEditingController _usernameOrEmailController =
  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2A0F14),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: const Color(0xFFFF9B8F).withOpacity(0.55),
          ),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFFF9B8F),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _getEmailFromUsername(String username) async {
    final QuerySnapshot<Map<String, dynamic>> userResult =
    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (userResult.docs.isEmpty) {
      return null;
    }

    final Map<String, dynamic> userData = userResult.docs.first.data();

    if (userData['email'] == null || userData['email'].toString().isEmpty) {
      return null;
    }

    return userData['email'].toString();
  }

  Future<void> _login() async {
    final String usernameOrEmail = _usernameOrEmailController.text.trim();
    final String password = _passwordController.text.trim();

    if (usernameOrEmail.isEmpty || password.isEmpty) {
      _showMessage('Please enter your username/email and password.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String emailForLogin = usernameOrEmail;

      if (!usernameOrEmail.contains('@')) {
        final String? foundEmail = await _getEmailFromUsername(usernameOrEmail);

        if (foundEmail == null) {
          if (mounted) {
            _showMessage('No account found. Please create a profile first.');
          }
          return;
        }

        emailForLogin = foundEmail;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailForLogin,
        password: password,
      );

      if (!mounted) {
        return;
      }

      widget.onLoginSuccess();
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }

      if (error.code == 'user-not-found') {
        _showMessage('No account found. Please create a profile first.');
      } else if (error.code == 'wrong-password') {
        _showMessage('Wrong password. Please try again.');
      } else if (error.code == 'invalid-email') {
        _showMessage('This email address is not valid.');
      } else if (error.code == 'invalid-credential') {
        _showMessage('Username/email or password is wrong. Please try again.');
      } else if (error.code == 'user-disabled') {
        _showMessage('This account has been disabled.');
      } else if (error.code == 'too-many-requests') {
        _showMessage('Too many attempts. Please try again later.');
      } else if (error.code == 'network-request-failed') {
        _showMessage('Network error. Please check your internet connection.');
      } else {
        _showMessage('Login failed. Please try again.');
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage('Something went wrong. Please try again.');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    final String usernameOrEmail = _usernameOrEmailController.text.trim();

    if (usernameOrEmail.isEmpty) {
      _showMessage('Please enter your username or email address first.');
      return;
    }

    try {
      String emailForReset = usernameOrEmail;

      if (!usernameOrEmail.contains('@')) {
        final String? foundEmail = await _getEmailFromUsername(usernameOrEmail);

        if (foundEmail == null) {
          if (mounted) {
            _showMessage('No account found. Please create a profile first.');
          }
          return;
        }

        emailForReset = foundEmail;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailForReset,
      );

      if (!mounted) {
        return;
      }

      _showMessage('Password reset email has been sent.');
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }

      if (error.code == 'user-not-found') {
        _showMessage('No account found. Please create a profile first.');
      } else if (error.code == 'invalid-email') {
        _showMessage('This email address is not valid.');
      } else {
        _showMessage('Could not send password reset email.');
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage('Something went wrong. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF9B8F),
                    Color(0xFF18D7FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF18D7FF).withOpacity(0.18),
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: const Offset(-8, 0),
                  ),
                  BoxShadow(
                    color: const Color(0xFFFF8D84).withOpacity(0.15),
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: const Offset(8, 0),
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF111317),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white70,
                  size: 42,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'LOGIN WITH YOUR PROFILE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF18D7FF),
                fontSize: 13,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 26),
          LoginTextField(
            controller: _usernameOrEmailController,
            label: 'USERNAME OR EMAIL',
            hintText: 'username or email@example.com',
            trailingIcon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          LoginTextField(
            controller: _passwordController,
            label: 'PASSWORD',
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
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  setState(() {
                    _rememberMe = !_rememberMe;
                  });
                },
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _rememberMe
                            ? const Color(0xFF18D7FF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: _rememberMe
                              ? const Color(0xFF18D7FF)
                              : Colors.white.withOpacity(0.22),
                        ),
                      ),
                      child: _rememberMe
                          ? const Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 16,
                      )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: Color(0xFFB8BDC6),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF18D7FF),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 34),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF18D7FF),
                    Color(0xFFFF9B8F),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
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
                    : const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CreateProfileButton(onTap: widget.onCreateProfileTap),
        ],
      ),
    );
  }
}

class _CreateProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateProfileButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white.withOpacity(0.08),
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: const Text(
            'CREATE PROFILE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}