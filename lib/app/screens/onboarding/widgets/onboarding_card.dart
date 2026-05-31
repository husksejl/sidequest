import 'package:flutter/material.dart';

import '../models/onboarding_step.dart';

class OnboardingCard extends StatelessWidget {
  final OnboardingStep step;
  final int index;

  const OnboardingCard({
    super.key,
    required this.step,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        children: [
          Text(
            step.eyebrow,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFF7F6F),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0B1014),
                    Color(0xFF0E1116),
                    Color(0xFF12161B),
                  ],
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D9E8).withValues(alpha: 0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool compact = constraints.maxHeight < 520;

                  return Stack(
                    children: [
                      const Positioned.fill(
                        child: _CardBackground(),
                      ),

                      Column(
                        children: [
                          Expanded(
                            flex: compact ? 5 : 6,
                            child: _VisualStoryArea(
                              imagePath: step.imagePath,
                              index: index,
                              compact: compact,
                            ),
                          ),
                          Expanded(
                            flex: compact ? 5 : 4,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                24,
                                compact ? 6 : 10,
                                24,
                                compact ? 16 : 22,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _StepBadge(index: index),
                                  SizedBox(height: compact ? 10 : 14),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: compact ? 23 : 27,
                                        height: 1.08,
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context).colorScheme.onSurface,
                                        letterSpacing: -0.8,
                                      ),
                                      children: [
                                        TextSpan(text: step.title),
                                        TextSpan(
                                          text: step.highlightedTitle,
                                          style: TextStyle(
                                            color: Color(0xFF00D9E8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: compact ? 8 : 12),
                                  Flexible(
                                    child: Text(
                                      step.description,
                                      textAlign: TextAlign.center,
                                      maxLines: compact ? 3 : 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.68),
                                        fontSize: compact ? 12.5 : 14,
                                        height: 1.45,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBackground extends StatelessWidget {
  const _CardBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -70,
          right: -60,
          child: _GlowBlob(
            size: 190,
            color: const Color(0xFF00D9E8).withValues(alpha: 0.10),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -70,
          child: _GlowBlob(
            size: 190,
            color: const Color(0xFFFF7F6F).withValues(alpha: 0.08),
          ),
        ),
        Positioned(
          top: 120,
          left: -40,
          child: _GlowBlob(
            size: 120,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.02),
          ),
        ),
      ],
    );
  }
}

class _VisualStoryArea extends StatelessWidget {
  final String imagePath;
  final int index;
  final bool compact;

  const _VisualStoryArea({
    required this.imagePath,
    required this.index,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = compact ? 132 : 158;
    final double imageWidth = compact ? 210 : 240;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: compact ? 18 : 24,
          left: 28,
          child: _FloatingIcon(
            icon: _secondaryIcon(index),
            color: const Color(0xFFFF7F6F),
            size: compact ? 42 : 48,
            rotation: -0.16,
          ),
        ),
        Positioned(
          top: compact ? 20 : 28,
          right: 28,
          child: _FloatingIcon(
            icon: _mainIcon(index),
            color: const Color(0xFF00D9E8),
            size: compact ? 48 : 56,
            rotation: 0.14,
          ),
        ),
        Positioned(
          bottom: compact ? 14 : 18,
          child: _TinyPill(index: index),
        ),
        Transform.rotate(
          angle: index == 1 ? -0.055 : 0.045,
          child: SizedBox(
            width: imageWidth + 22,
            height: imageHeight + 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 10,
                  top: 8,
                  child: Container(
                    height: imageHeight,
                    width: imageWidth,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                ),
                _PreviewCard(
                  imagePath: imagePath,
                  width: imageWidth,
                  height: imageHeight,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _mainIcon(int index) {
    if (index == 0) return Icons.rocket_launch_rounded;
    if (index == 1) return Icons.bolt_rounded;
    return Icons.favorite_rounded;
  }

  IconData _secondaryIcon(int index) {
    if (index == 0) return Icons.explore_rounded;
    if (index == 1) return Icons.calendar_month_rounded;
    return Icons.groups_rounded;
  }
}

class _PreviewCard extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const _PreviewCard({
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF26393D),
                        Color(0xFF101416),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.image_rounded,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
                    size: 42,
                  ),
                );
              },
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.02),
                      Colors.black.withValues(alpha: 0.08),
                      Colors.black.withValues(alpha: 0.22),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  final int index;

  const _StepBadge({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String text = 'THE CALL';
    IconData icon = Icons.explore_rounded;

    if (index == 1) {
      text = 'DAILY QUEST';
      icon = Icons.calendar_month_rounded;
    }

    if (index == 2) {
      text = 'SHARE IT';
      icon = Icons.groups_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF00D9E8).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: const Color(0xFF00D9E8).withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF00D9E8),
            size: 15,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF00D9E8),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double rotation;

  const _FloatingIcon({
    required this.icon,
    required this.color,
    required this.size,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: const Color(0xFF071012),
          size: size * 0.46,
        ),
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  final int index;

  const _TinyPill({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String text = 'Outside the feed';
    IconData icon = Icons.location_on_rounded;

    if (index == 1) {
      text = 'One step today';
      icon = Icons.check_rounded;
    }

    if (index == 2) {
      text = 'Friends are active';
      icon = Icons.favorite_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF00D9E8),
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowBlob({
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
            blurRadius: 90,
            spreadRadius: 34,
          ),
        ],
      ),
    );
  }
}