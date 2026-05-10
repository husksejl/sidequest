import 'package:flutter/material.dart';

import '../../login/login_page.dart';
import 'create_account_text_field.dart';
import 'profile_photo_picker.dart';

class CreateAccountFormCard extends StatefulWidget {
  const CreateAccountFormCard({super.key});

  @override
  State<CreateAccountFormCard> createState() => _CreateAccountFormCardState();
}

class _CreateAccountFormCardState extends State<CreateAccountFormCard> {
  bool _acceptedTerms = true;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
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
          const ProfilePhotoPicker(),
          const SizedBox(height: 26),
          const CreateAccountTextField(
            label: 'FULL NAME',
            hintText: 'Alex Explorer',
            trailingIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 16),
          const CreateAccountTextField(
            label: 'USERNAME',
            hintText: 'alexexplores',
            trailingIcon: Icons.alternate_email_rounded,
          ),
          const SizedBox(height: 16),
          const CreateAccountTextField(
            label: 'EMAIL',
            hintText: 'alex@example.com',
            trailingIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CreateAccountTextField(
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
          CreateAccountTextField(
            label: 'CONFIRM PASSWORD',
            hintText: '••••••••••••',
            trailingIcon: Icons.lock_outline_rounded,
            obscureText: !_showConfirmPassword,
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
          const SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
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
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to the ',
                        children: [
                          TextSpan(
                            text: 'Terms & Privacy Policy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      style: TextStyle(
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
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF18D7FF),
                    Color(0xFFFF9B8F),
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
                onPressed: _acceptedTerms ? () {} : null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
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
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: const Text.rich(
              TextSpan(
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    text: 'LOG IN',
                    style: TextStyle(
                      color: Color(0xFF18D7FF),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
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