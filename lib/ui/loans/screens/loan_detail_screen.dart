import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../di/datasource_providers.dart';
import 'installments_screen.dart';

final loanDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  return ref.watch(loansServiceProvider).loanDetail(id);
});

class LoanDetailScreen extends ConsumerWidget {
  const LoanDetailScreen({super.key, required this.loanId});

  final String loanId;

  static const routeName = 'loan_detail';
  static String routePath(String id) => '/loans/$id';
  static const _bg = Color(0xFFF6F7F8);
  static const _primary = Color(0xFF0A202E);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loan = ref.watch(loanDetailProvider(loanId));

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Detalle del crédito'),
        backgroundColor: Colors.white,
        foregroundColor: _primary,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: loan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) {
          final normalized = _normalizeMap(data);

          final amount = _num(normalized['amount']);
          final currency = normalized['currency']?.toString();
          final status = normalized['status']?.toString();
          final interestRate = _num(normalized['interestRate']);
          final termMonths = _int(normalized['termMonths']);
          final interestType = normalized['interestType']?.toString();
          final createdAt = normalized['createdAt']?.toString();
          final updatedAt = normalized['updatedAt']?.toString();

          final money = _formatMoney(amount, currency: currency);
          final statusLabel = (status ?? 'DESCONOCIDO').trim().isEmpty
              ? 'DESCONOCIDO'
              : (status ?? 'DESCONOCIDO').trim().toUpperCase();
          final statusColor = _statusColor(statusLabel);

          final idShort = _shortId(loanId);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _SummaryCard(
                moneyText: money,
                statusText: statusLabel,
                statusColor: statusColor,
              ),
              const SizedBox(height: 16),
              const _SectionTitle(text: 'INFORMACIÓN DEL PRÉSTAMO'),
              const SizedBox(height: 10),
              _InfoCard(
                children: [
                  _InfoRow(
                    label: 'ID del crédito',
                    value: idShort,
                    valueMaxLines: 1,
                  ),
                  _InfoRow(
                    label: 'Tasa de Interés',
                    value: interestRate == null ? '-' : '${interestRate.toString()}%',
                  ),
                  _InfoRow(
                    label: 'Plazo',
                    value: termMonths == null ? '-' : '$termMonths meses',
                  ),
                  _InfoRow(
                    label: 'Tipo de Interés',
                    value: _prettyInterestType(interestType),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _SectionTitle(text: 'FECHAS'),
              const SizedBox(height: 10),
              _InfoCard(
                children: [
                  _InfoRow(
                    label: 'Fecha de creación',
                    value: _formatDateEs(createdAt),
                  ),
                  _InfoRow(
                    label: 'Última actualización',
                    value: _formatDateEs(updatedAt),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _BottomPrimaryButton(
                text: 'Ver cronograma de cuotas',
                onPressed: () => context.push(InstallmentsScreen.routePath(loanId)),
              ),
            ],
          );
        },
      ),
    );
  }

  static Map<String, Object?> _normalizeMap(Map<String, dynamic> raw) {
    final out = <String, Object?>{};
    for (final entry in raw.entries) {
      final key = entry.key.toString();
      out[key] = entry.value;
    }
    return out;
  }

  static num? _num(Object? v) {
    if (v is num) return v;
    return num.tryParse('${v ?? ''}');
  }

  static int? _int(Object? v) {
    if (v is int) return v;
    return int.tryParse('${v ?? ''}');
  }

  static String _shortId(String id) {
    if (id.length <= 16) return id;
    return '${id.substring(0, 14)}…';
  }

  static Color _statusColor(String statusUpper) {
    if (statusUpper.contains('ACTIVE') || statusUpper.contains('APPROVED')) {
      return const Color(0xFF16A34A);
    }
    if (statusUpper.contains('PENDING') || statusUpper.contains('REVIEW')) {
      return const Color(0xFFF59E0B);
    }
    if (statusUpper.contains('REJECT') || statusUpper.contains('CANCEL') || statusUpper.contains('DENIED')) {
      return const Color(0xFFEF4444);
    }
    return _muted;
  }

  static String _formatMoney(num? value, {String? currency}) {
    if (value == null) return '-';
    final symbol = (currency ?? '').toUpperCase() == 'USD' ? r'$' : 'S/';
    final s = value.toStringAsFixed(0);
    return '$symbol${_thousands(s)}';
  }

  static String _thousands(String digits) {
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final idxFromEnd = digits.length - i;
      buf.write(digits[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  static String _prettyInterestType(String? raw) {
    final s = (raw ?? '').toUpperCase();
    if (s.isEmpty) return '-';
    if (s.contains('FIXED')) return 'Fijo Anual';
    if (s.contains('VARIABLE')) return 'Variable';
    return raw!;
  }

  static String _formatDateEs(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    try {
      final dt = DateTime.parse(raw).toLocal();
      const months = <String>[
        'enero',
        'febrero',
        'marzo',
        'abril',
        'mayo',
        'junio',
        'julio',
        'agosto',
        'septiembre',
        'octubre',
        'noviembre',
        'diciembre',
      ];
      return '${dt.day} de ${months[dt.month - 1]}, ${dt.year}';
    } catch (_) {
      return raw;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.moneyText,
    required this.statusText,
    required this.statusColor,
  });

  final String moneyText;
  final String statusText;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LoanDetailScreen._border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
              color: LoanDetailScreen._muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            moneyText,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: LoanDetailScreen._primary,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LoanDetailScreen._border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
              const Divider(height: 1, thickness: 1, color: LoanDetailScreen._border),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueMaxLines,
  });

  final String label;
  final String value;
  final int? valueMaxLines;

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
                color: LoanDetailScreen._muted,
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

class _BottomPrimaryButton extends StatelessWidget {
  const _BottomPrimaryButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: LoanDetailScreen._primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
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

