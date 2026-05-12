import 'package:flutter/material.dart';

class CreateAccountTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final IconData trailingIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? extraTrailing;
  final TextInputAction textInputAction;

  const CreateAccountTextField({
    super.key,
    this.controller,
    required this.label,
    required this.hintText,
    required this.trailingIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.extraTrailing,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE1E5EC),
              fontSize: 12,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF080D12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.09)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.26),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autocorrect: !obscureText,
            enableSuggestions: !obscureText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            cursorColor: const Color(0xFF18D7FF),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF68717E),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 17,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    trailingIcon,
                    color: Colors.white70,
                    size: 22,
                  ),
                  if (extraTrailing != null) ...[
                    const SizedBox(width: 12),
                    extraTrailing!,
                  ],
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}