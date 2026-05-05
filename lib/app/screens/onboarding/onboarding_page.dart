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
      highlightedTitle: 'per day.',
      description:
      'No clutter, no pressure. Just one small quest every 24 hours to get you moving, creating or connecting.',
      imagePath: 'assets/images/onboarding_daily.png',
      buttonText: 'Next',
    ),
    OnboardingStep(
      eyebrow: 'Share Moments',
      title: 'Share real moments\n',
      highlightedTitle: 'with others.',
      description:
      'Capture your quest, see how others solved theirs and turn simple challenges into shared memories.',
      imagePath: 'assets/images/onboarding_share.png',
      buttonText: 'Start your journey',
    ),
  ];

  bool get _isLastStep => _currentIndex == _steps.length - 1;

  void _nextStep() {
    if (_isLastStep) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _skipOnboarding() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    if (widget.onFinished != null) {
      widget.onFinished!(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Onboarding finished. Connect this to your signup page.'),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      body: SafeArea(
        child: Stack(
          children: [
            const _BackgroundGlow(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                  child: Row(
                    children: [
                      const Text(
                        'SideQuest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _skipOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withOpacity(0.62),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

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

                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 14),
                  child: Column(
                    children: [
                      OnboardingProgress(
                        currentIndex: _currentIndex,
                        totalSteps: _steps.length,
                      ),

                      const SizedBox(height: 16),

                      OnboardingActionButton(
                        text: _steps[_currentIndex].buttonText,
                        icon: _isLastStep
                            ? Icons.rocket_launch_rounded
                            : Icons.arrow_forward_rounded,
                        onPressed: _nextStep,
                      ),

                      const SizedBox(height: 16),

                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        opacity: _isLastStep ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !_isLastStep,
                          child: TextButton(
                            onPressed: _isLastStep ? _finishOnboarding : null,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white.withOpacity(0.5),
                            ),
                            child: const Text(
                              'Already have an account? Sign in',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -90,
          right: -70,
          child: _GlowCircle(
            size: 220,
            color: const Color(0xFF00D9E8).withOpacity(0.18),
          ),
        ),
        Positioned(
          bottom: 150,
          left: -100,
          child: _GlowCircle(
            size: 240,
            color: const Color(0xFFFF7F6F).withOpacity(0.13),
          ),
        ),
        Positioned(
          bottom: -80,
          right: -80,
          child: _GlowCircle(
            size: 220,
            color: const Color(0xFF00D9E8).withOpacity(0.12),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 120,
            spreadRadius: 60,
          ),
        ],
      ),
    );
  }
}