import 'package:flutter/material.dart';

import '../../../models/loan_summary.dart';

class MyLoansPrimaryCtaButton extends StatelessWidget {
  const MyLoansPrimaryCtaButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0A202E),
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
          child: const Text(
            'Solicitar un crédito',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class MyLoansSectionTitle extends StatelessWidget {
  const MyLoansSectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
    required this.loan,
    required this.onTap,
  });

  final LoanSummary loan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final amountText = _formatMoney(loan.amount, currency: loan.currency);
    final status = (loan.status ?? '').trim();

    final statusColor = _statusColor(status);
    final statusLabel = status.isEmpty ? 'DESCONOCIDO' : status.toUpperCase();

    final subtitleId = loan.id.isEmpty ? '' : '#${_shortId(loan.id)}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Préstamo $subtitleId',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0A202E),
                    height: 1,
                  ),
                ),
                const SizedBox(width: 10),
                const Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    'Monto Total',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
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
                  'ESTADO: $statusLabel',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _shortId(String id) {
    if (id.length <= 10) return id;
    return '${id.substring(0, 8)}…${id.substring(id.length - 4)}';
  }

  static Color _statusColor(String status) {
    final s = status.toUpperCase();
    if (s.contains('ACTIVE') || s.contains('APPROVED') || s.contains('CURRENT')) {
      return const Color(0xFF16A34A);
    }
    if (s.contains('PENDING') || s.contains('UNDER') || s.contains('REVIEW')) {
      return const Color(0xFFF59E0B);
    }
    if (s.contains('REJECT') || s.contains('CANCEL') || s.contains('DENIED')) {
      return const Color(0xFFEF4444);
    }
    return const Color(0xFF64748B);
  }

  static String _formatMoney(num? value, {String? currency}) {
    if (value == null) return '-';
    final symbol = (currency ?? '').toUpperCase() == 'USD' ? r'$' : 'S/';
    final s = value.toStringAsFixed(0);
    final withSep = _thousands(s);
    return '$symbol$withSep';
  }

  static String _thousands(String digits) {
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final idxFromEnd = digits.length - i;
      buf.write(digits[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return buf.toString();
  }
}

class EmptyLoansView extends StatelessWidget {
  const EmptyLoansView({super.key, required this.onNewRequest});

  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.credit_card, size: 48, color: Color(0xFF0A202E)),
          const SizedBox(height: 12),
          const Text(
            'Aún no tienes préstamos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Puedes solicitar un crédito y te avisaremos cuando sea aprobado.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNewRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A202E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Nueva solicitud'),
            ),
          ),
        ],
      ),
    );
  }
}

class MyLoansErrorView extends StatelessWidget {
  const MyLoansErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 44, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(
            'No se pudieron cargar tus créditos',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

