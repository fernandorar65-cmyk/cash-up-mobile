import 'package:flutter/material.dart';

class AuthLabeledTextField extends StatelessWidget {
  const AuthLabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            prefixIcon:
                prefixIcon == null ? null : Icon(prefixIcon, color: Colors.grey.shade500),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: Color(0xFF0A202E),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

