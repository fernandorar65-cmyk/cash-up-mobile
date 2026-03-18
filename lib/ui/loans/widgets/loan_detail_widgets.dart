import 'package:flutter/material.dart';

class LoanDetailSummaryCard extends StatelessWidget {
  const LoanDetailSummaryCard({
    super.key,
    required this.moneyText,
    required this.statusText,
    required this.statusColor,
  });

  final String moneyText;
  final String statusText;
  final Color statusColor;

  static const _primary = Color(0xFF0A202E);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        children: [
          const Text(
            'Monto Total',
            style: TextStyle(
              color: _muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            moneyText,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: _primary,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ESTADO: $statusText',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoanDetailSectionTitle extends StatelessWidget {
  const LoanDetailSectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.4,
        color: Color(0xFF94A3B8),
      ),
    );
  }
}

class LoanDetailInfoCard extends StatelessWidget {
  const LoanDetailInfoCard({super.key, required this.children});

  final List<Widget> children;

  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(height: 1, thickness: 1, color: _border),
          ],
        ],
      ),
    );
  }
}

class LoanDetailInfoRow extends StatelessWidget {
  const LoanDetailInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueMaxLines,
  });

  final String label;
  final String value;
  final int? valueMaxLines;

  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              maxLines: valueMaxLines ?? 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoanDetailPrimaryButton extends StatelessWidget {
  const LoanDetailPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  static const _primary = Color(0xFF0A202E);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

