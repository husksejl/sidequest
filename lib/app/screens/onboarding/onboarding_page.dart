import 'package:flutter/material.dart';

import 'models/onboarding_step.dart';
import 'widgets/onboarding_action_button.dart';
import 'widgets/onboarding_card.dart';
import 'widgets/onboarding_progress.dart';

class OnboardingPage extends StatefulWidget {
  final void Function(BuildContext context)? onFinished;

  const OnboardingPage({
    super.key,
    this.onFinished,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  final List<OnboardingStep> _steps = const [
    OnboardingStep(
      eyebrow: 'SideQuest',
      title: 'Stop scrolling.\n',
      highlightedTitle: 'Start doing.',
      description:
      'Turn digital boredom into tiny real-world adventures. Your next story starts outside the feed.',
      imagePath: 'assets/images/onboarding_start.png',
      buttonText: 'Mission Start',
    ),
    OnboardingStep(
      eyebrow: 'Daily Challenge',
      title: 'One challenge\n',
      highlightedTitle: 'every day.',
      description:
      'Each day brings a small quest. It could be creative, social, weird, wholesome or completely chaotic.',
      imagePath: 'assets/images/onboarding_daily.png',
      buttonText: 'Next Quest',
    ),
    OnboardingStep(
      eyebrow: 'Share Your Proof',
      title: 'Capture it.\n',
      highlightedTitle: 'Post it.',
      description:
      'Upload your solution, see how others solved the same challenge and collect tiny memories along the way.',
      imagePath: 'assets/images/onboarding_share.png',
      buttonText: 'Continue',
    ),
    OnboardingStep(
      eyebrow: 'Group Quests',
      title: 'Join forces.\n',
      highlightedTitle: 'Create chaos.',
      description:
      'Take on challenges with friends, groups or strangers and turn everyday moments into shared missions.',
      imagePath: 'assets/images/onboarding_groups.png',
      buttonText: 'Get Started',
    ),
  ];

  bool get _isLastPage => _currentIndex == _steps.length - 1;

  void _handleButtonPressed() {
    if (_isLastPage) {
      widget.onFinished?.call(context);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _steps[_currentIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    widget.onFinished?.call(context);
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF8B8F98),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _steps.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingCard(
                      step: _steps[index],
                      index: index,
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              OnboardingProgress(
                currentIndex: _currentIndex,
                totalSteps: _steps.length,
              ),
              const SizedBox(height: 24),
              OnboardingActionButton(
                text: currentStep.buttonText,
                onPressed: _handleButtonPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}