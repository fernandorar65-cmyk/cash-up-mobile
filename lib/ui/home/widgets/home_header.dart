import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.title,
    this.onBack,
    this.onInfo,
  });

  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onInfo;

  static const _primary = Color(0xFF0A202E);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: _primary,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primary,
              ),
            ),
          ),
          IconButton(
            onPressed: onInfo,
            icon: const Icon(Icons.info_outline),
            color: _primary,
          ),
        ],
      ),
    );
  }
}

