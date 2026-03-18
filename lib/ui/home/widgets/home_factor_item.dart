import 'package:flutter/material.dart';

class HomeFactorItem extends StatelessWidget {
  const HomeFactorItem({
    super.key,
    required this.icon,
    required this.title,
    required this.label,
    required this.percent,
  });

  final IconData icon;
  final String title;
  final String label;
  final double percent;

  static const _primary = Color(0xFF0A202E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: _primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(_primary),
          ),
        ),
      ],
    );
  }
}

