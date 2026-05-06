import 'package:flutter/material.dart';

import 'widgets/create_account_form_card.dart';
import 'widgets/create_account_header.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  static const String routeName = '/create-account';
  static const Color bgColor = Color(0xFF050608);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CreateAccountHeader(),
              SizedBox(height: 34),
              Text(
                'JOIN THE QUEST',
                style: TextStyle(
                  color: Color(0xFF18D7FF),
                  fontSize: 13,
                  letterSpacing: 4.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'CREATE\nACCOUNT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  height: 0.95,
                  letterSpacing: -1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Start your adventure and share your daily SideQuests.',
                style: TextStyle(
                  color: Color(0xFF9AA0AA),
                  fontSize: 15,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 26),
              CreateAccountFormCard(),
              SizedBox(height: 22),
              Center(
                child: Text(
                  '✦   Your next SideQuest starts here.   ✦',
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
