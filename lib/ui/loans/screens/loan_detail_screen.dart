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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loan = ref.watch(loanDetailProvider(loanId));

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Detalle del crédito'),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
      ),
      body: loan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) {
          final normalized = _normalizeMap(data);
          final ordered = _orderedEntries(normalized);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F0FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE7D9FF)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: $loanId',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...ordered.map(
                      (e) => _KeyValueRow(
                        label: e.$1,
                        value: e.$2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push(InstallmentsScreen.routePath(loanId)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Ver cronograma (cuotas)'),
                ),
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

  static List<(String, String)> _orderedEntries(Map<String, Object?> data) {
    String v(Object? x) => _formatValue(x);

    final preferredKeys = <String>[
      'id',
      'clientId',
      'amount',
      'interestRate',
      'termMonths',
      'interestType',
      'status',
      'createdAt',
      'updatedAt',
    ];

    final items = <(String, String)>[];
    for (final k in preferredKeys) {
      if (data.containsKey(k)) items.add((_prettyKey(k), v(data[k])));
    }

    final remaining = data.keys
        .where((k) => !preferredKeys.contains(k))
        .toList()
      ..sort();
    for (final k in remaining) {
      items.add((_prettyKey(k), v(data[k])));
    }

    return items;
  }

  static String _prettyKey(String key) {
    switch (key) {
      case 'clientId':
        return 'clientId';
      case 'interestRate':
        return 'interestRate';
      case 'termMonths':
        return 'termMonths';
      case 'interestType':
        return 'interestType';
      case 'createdAt':
        return 'createdAt';
      case 'updatedAt':
        return 'updatedAt';
      default:
        return key;
    }
  }

  static String _formatValue(Object? value) {
    if (value == null) return '-';

    if (value is num) {
      final asInt = value % 1 == 0;
      return asInt ? value.toStringAsFixed(0) : value.toString();
    }

    final s = value.toString();
    if (_looksLikeIsoDate(s)) {
      return s.replaceFirst('T', ' ').replaceFirst('Z', '');
    }
    return s;
  }

  static bool _looksLikeIsoDate(String s) {
    // Ej: 2026-03-18T18:02:23.182Z
    return RegExp(r'^\d{4}-\d{2}-\d{2}T').hasMatch(s);
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 13,
          height: 1.25,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }
}

