import 'package:flutter/material.dart';

import '../models/group_challenge.dart';

class ChallengeDetailPage extends StatelessWidget {
  final GroupChallenge challenge;

  const ChallengeDetailPage({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildHero(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStats(context),
                        const SizedBox(height: 28),
                        _buildSectionTitle(context, 'The Brief'),
                        const SizedBox(height: 10),
                        Text(
                          challenge.description,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                            height: 1.5,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildSectionTitle(context, 'Quest Ideas'),
                        const SizedBox(height: 14),
                        ...challenge.questIdeas.map(
                              (idea) => _buildQuestIdea(context, idea),
                        ),
                        const SizedBox(height: 24),
                        _buildReadyCard(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF00D7E8),
            ),
          ),
          const Spacer(),
          CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xFF1C1F24),
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onSurface,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            challenge.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF111820),
                child: Icon(
                  Icons.landscape_rounded,
                  color: Color(0xFF00D7E8),
                  size: 70,
                ),
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSmallBadge(challenge.category),
                const SizedBox(height: 12),
                Text(
                  challenge.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  challenge.subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF0E3E44),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00D7E8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF00D7E8),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(context, 'Reward', challenge.reward),
        ),
        Expanded(
          child: _buildStatItem(context, 'Time', challenge.time),
        ),
        Expanded(
          child: _buildStatItem(context, 'Level', challenge.level),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Color(0xFFFF7668),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildQuestIdea(BuildContext context, String idea) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF20262E),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF0E3E44),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Color(0xFF00D7E8),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              idea,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111419),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFF7668).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to start?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This quest begins in groups. Complete the task and upload your proof once your journey begins.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7668),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Complete Now',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SAVE FOR LATER',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}