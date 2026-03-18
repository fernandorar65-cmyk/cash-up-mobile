import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../di/datasource_providers.dart';
import 'installments_screen.dart';
import '../widgets/loan_detail_widgets.dart';

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
              LoanDetailSummaryCard(
                moneyText: money,
                statusText: statusLabel,
                statusColor: statusColor,
              ),
              const SizedBox(height: 16),
              const LoanDetailSectionTitle(text: 'INFORMACIÓN DEL PRÉSTAMO'),
              const SizedBox(height: 10),
              LoanDetailInfoCard(
                children: [
                  LoanDetailInfoRow(
                    label: 'ID del crédito',
                    value: idShort,
                    valueMaxLines: 1,
                  ),
                  LoanDetailInfoRow(
                    label: 'Tasa de Interés',
                    value: interestRate == null ? '-' : '${interestRate.toString()}%',
                  ),
                  LoanDetailInfoRow(
                    label: 'Plazo',
                    value: termMonths == null ? '-' : '$termMonths meses',
                  ),
                  LoanDetailInfoRow(
                    label: 'Tipo de Interés',
                    value: _prettyInterestType(interestType),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const LoanDetailSectionTitle(text: 'FECHAS'),
              const SizedBox(height: 10),
              LoanDetailInfoCard(
                children: [
                  LoanDetailInfoRow(
                    label: 'Fecha de creación',
                    value: _formatDateEs(createdAt),
                  ),
                  LoanDetailInfoRow(
                    label: 'Última actualización',
                    value: _formatDateEs(updatedAt),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LoanDetailPrimaryButton(
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

