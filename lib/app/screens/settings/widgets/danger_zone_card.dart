import 'package:flutter/material.dart';

class DangerZoneCard extends StatelessWidget {
  const DangerZoneCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0E12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFF8D84).withOpacity(0.18)),
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
                child: const Icon(
                  Icons.warning_rounded,
                  color: Color(0xFFFF8D84),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danger zone',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sign out or permanently delete your account.',
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
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DangerButton(
                  label: 'LOG OUT',
                  icon: Icons.logout_rounded,
                  filled: false,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DangerButton(
                  label: 'DELETE',
                  icon: Icons.delete_rounded,
                  filled: true,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _DangerButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: filled ? const Color(0xFFFF8D84) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFFF8D84).withOpacity(0.35)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: filled ? Colors.black : const Color(0xFFFF8D84),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: filled ? Colors.black : const Color(0xFFFF8D84),
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
