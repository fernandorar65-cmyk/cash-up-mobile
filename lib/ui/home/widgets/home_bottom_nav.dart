import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Row(
        children: [
          _HomeBottomNavItem(
            icon: Icons.home_outlined,
            label: 'Inicio',
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _HomeBottomNavItem(
            icon: Icons.credit_card,
            label: 'Solicitudes',
            selected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _HomeBottomNavItem(
            icon: Icons.person_outline,
            label: 'Perfil',
            selected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class _HomeBottomNavItem extends StatelessWidget {
  const _HomeBottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? const Color(0xFF0A202E) : const Color(0xFF94A3B8);
    final fontWeight = selected ? FontWeight.w700 : FontWeight.w500;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: fontWeight,
                  letterSpacing: 1.2,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

