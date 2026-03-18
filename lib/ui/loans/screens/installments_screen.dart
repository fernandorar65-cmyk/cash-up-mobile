import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/datasource_providers.dart';
import '../../../services/loans/models/installment.dart';

final installmentsProvider = FutureProvider.family<List<Installment>, String>((ref, loanId) async {
  return ref.watch(loansServiceProvider).installments(loanId);
});

final loanDetailForInstallmentsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, loanId) async {
  return ref.watch(loansServiceProvider).loanDetail(loanId);
});

class InstallmentsScreen extends ConsumerWidget {
  const InstallmentsScreen({super.key, required this.loanId});

  final String loanId;

  static const routeName = 'installments';
  static String routePath(String loanId) => '/loans/$loanId/installments';

  static const _bg = Color(0xFFF6F7F8);
  // colores principales se definen en widgets internos

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installments = ref.watch(installmentsProvider(loanId));
    final loanDetail = ref.watch(loanDetailForInstallmentsProvider(loanId));

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Cronograma'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: _Body(
        loanId: loanId,
        installments: installments,
        loanDetail: loanDetail,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.loanId,
    required this.installments,
    required this.loanDetail,
  });

  final String loanId;
  final AsyncValue<List<Installment>> installments;
  final AsyncValue<Map<String, dynamic>> loanDetail;

  @override
  Widget build(BuildContext context) {
    return installments.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('No hay cuotas para este préstamo'));
        }

        final sorted = [...items]
          ..sort((a, b) => (a.number ?? 0).compareTo(b.number ?? 0));

        final nextDue = _nextDueDate(sorted);
        final remainingCount = _remainingCount(sorted);
        final remainingAmount = _remainingAmount(sorted);

        final title = loanDetail.maybeWhen(
          data: (d) => (d['name'] ?? d['productName'] ?? d['loanName'])?.toString(),
          orElse: () => null,
        );
        final currency = loanDetail.maybeWhen(
          data: (d) => d['currency']?.toString(),
          orElse: () => null,
        );

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            _Header(
              title: title ?? 'Línea de Crédito Personal',
              nextDueText: _formatDateShortEs(nextDue) ?? '-',
              remainingText: _formatMoney(remainingAmount, currency: currency),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  for (final it in sorted) ...[
                    _InstallmentCard(installment: it),
                    const SizedBox(height: 10),
                  ],
                  if (remainingCount != null) ...[
                    const SizedBox(height: 6),
                    _RemainingBanner(remainingCount: remainingCount),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static DateTime? _nextDueDate(List<Installment> items) {
    DateTime? best;
    for (final it in items) {
      final status = (it.status ?? '').toUpperCase();
      if (status.contains('PAID') || status.contains('PAGADO')) continue;
      final due = _parseDate(it.dueDate);
      if (due == null) continue;
      if (best == null || due.isBefore(best)) best = due;
    }
    return best;
  }

  static int? _remainingCount(List<Installment> items) {
    var count = 0;
    var any = false;
    for (final it in items) {
      final status = (it.status ?? '').toUpperCase();
      if (status.contains('PAID') || status.contains('PAGADO')) {
        any = true;
        continue;
      }
      any = true;
      count++;
    }
    return any ? count : null;
  }

  static num? _remainingAmount(List<Installment> items) {
    num sum = 0;
    var any = false;
    for (final it in items) {
      final status = (it.status ?? '').toUpperCase();
      if (status.contains('PAID') || status.contains('PAGADO')) {
        any = true;
        continue;
      }
      any = true;
      sum += it.amount ?? 0;
    }
    return any ? sum : null;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.nextDueText,
    required this.remainingText,
  });

  final String title;
  final String nextDueText;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, top + 56, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A202E),
            Color(0xFF071824),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRÉSTAMO ACTIVO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Color(0xFF22C55E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeaderMetric(
                  label: 'PRÓXIMO VENCIMIENTO',
                  value: nextDueText,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _HeaderMetric(
                  label: 'RESTANTE',
                  value: remainingText,
                  valueEmphasis: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.label,
    required this.value,
    this.valueEmphasis = false,
  });

  final String label;
  final String value;
  final bool valueEmphasis;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: valueEmphasis ? 22 : 14,
            fontWeight: valueEmphasis ? FontWeight.w900 : FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _InstallmentCard extends StatelessWidget {
  const _InstallmentCard({required this.installment});

  final Installment installment;

  @override
  Widget build(BuildContext context) {
    final number = installment.number ?? 0;
    final status = (installment.status ?? '').toUpperCase();
    final due = _parseDate(installment.dueDate);
    final amountText = _formatMoney(installment.amount);

    final meta = _installmentMeta(status, number);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: meta.bg,
              shape: BoxShape.circle,
            ),
            child: Icon(meta.icon, color: meta.fg, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Cuota ${number == 0 ? '' : number}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      meta.badge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: meta.badgeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  meta.subtitle(due),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amountText,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _RemainingBanner extends StatelessWidget {
  const _RemainingBanner({required this.remainingCount});

  final int remainingCount;

  @override
  Widget build(BuildContext context) {
    final text = 'Tienes $remainingCount cuotas restantes para completar tu crédito';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF047857),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InstallmentMeta {
  const _InstallmentMeta({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.badge,
    required this.badgeColor,
    required this.subtitle,
  });

  final IconData icon;
  final Color bg;
  final Color fg;
  final String badge;
  final Color badgeColor;
  final String Function(DateTime? due) subtitle;
}

_InstallmentMeta _installmentMeta(String statusUpper, int number) {
  final s = statusUpper;

  if (s.contains('PAID') || s.contains('PAGADO')) {
    return _InstallmentMeta(
      icon: Icons.check,
      bg: const Color(0xFFDCFCE7),
      fg: const Color(0xFF16A34A),
      badge: 'PAGADO',
      badgeColor: const Color(0xFF16A34A),
      subtitle: (due) => 'Pagado el ${_formatDateShortEs(due) ?? '-'}',
    );
  }

  if (s.contains('PENDING') || s.contains('PENDIENTE')) {
    return _InstallmentMeta(
      icon: Icons.access_time_rounded,
      bg: const Color(0xFFEFF6FF),
      fg: const Color(0xFF1D4ED8),
      badge: 'PENDIENTE',
      badgeColor: const Color(0xFF059669),
      subtitle: (due) => 'Vence: ${_formatDateShortEs(due) ?? '-'}',
    );
  }

  // Próxima / por defecto
  return _InstallmentMeta(
    icon: Icons.lock_outline,
    bg: const Color(0xFFF1F5F9),
    fg: const Color(0xFF94A3B8),
    badge: 'PRÓXIMA',
    badgeColor: const Color(0xFF94A3B8),
    subtitle: (due) => 'Vence: ${_formatDateShortEs(due) ?? '-'}',
  );
}

DateTime? _parseDate(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  try {
    return DateTime.parse(raw).toLocal();
  } catch (_) {
    return null;
  }
}

String _formatMoney(num? value, {String? currency}) {
  if (value == null) return '-';
  final symbol = (currency ?? '').toUpperCase() == 'USD' ? r'$' : r'$';
  final s = value.toStringAsFixed(2);
  final parts = s.split('.');
  final whole = parts.first;
  final frac = parts.length > 1 ? parts[1] : '00';

  final buf = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final idxFromEnd = whole.length - i;
    buf.write(whole[i]);
    if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
  }

  return '$symbol${buf.toString()}.$frac';
}

String? _formatDateShortEs(DateTime? dt) {
  if (dt == null) return null;
  const months = <String>[
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];
  return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}, ${dt.year}';
}

