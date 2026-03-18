import 'package:flutter/material.dart';

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({
    super.key,
    required this.rightText,
    required this.onRightPressed,
  });

  final String rightText;
  final VoidCallback onRightPressed;

  static const _primary = Color(0xFF0A202E);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Center(
                child: Text(
                  'C',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'CashUp',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: _primary,
                fontSize: 18,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onRightPressed,
          style: TextButton.styleFrom(
            foregroundColor: _primary,
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          child: Text(
            rightText,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

