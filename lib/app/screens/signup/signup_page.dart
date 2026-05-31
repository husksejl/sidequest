import 'package:flutter/material.dart';
import 'package:sidequest/l10n/app_localizations.dart';

import 'widgets/create_account_form_card.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  static const String routeName = '/create-account';
  static const Color bgColor = Color(0xFF050608);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 34),
              Text(
                l10n.joinTheQuest,
                style: TextStyle(
                  color: Color(0xFF18D7FF),
                  fontSize: 13,
                  letterSpacing: 4.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.createAccountTitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 42,
                  height: 0.95,
                  letterSpacing: -1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.createAccountSubtitle,
                style: TextStyle(
                  color: Color(0xFF9AA0AA),
                  fontSize: 15,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 26),
              const CreateAccountFormCard(),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  l10n.signupFooter,
                  style: TextStyle(
                    color: Color(0xFF66707C),
                    fontSize: 13,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
