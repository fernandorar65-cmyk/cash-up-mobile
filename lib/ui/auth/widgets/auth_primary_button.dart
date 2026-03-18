import 'package:flutter/material.dart';

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF0A202E),
        borderRadius: BorderRadius.all(Radius.circular(14)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}

