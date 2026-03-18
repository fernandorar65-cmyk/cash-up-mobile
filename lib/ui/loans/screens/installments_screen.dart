import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/datasource_providers.dart';
import '../../../services/loans/models/installment.dart';

final installmentsProvider = FutureProvider.family<List<Installment>, String>((ref, loanId) async {
  return ref.watch(loansServiceProvider).installments(loanId);
});

class InstallmentsScreen extends ConsumerWidget {
  const InstallmentsScreen({super.key, required this.loanId});

  final String loanId;

  static const routeName = 'installments';
  static String routePath(String loanId) => '/loans/$loanId/installments';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installments = ref.watch(installmentsProvider(loanId));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: const Text('Cronograma'),
        backgroundColor: const Color(0xFF0A202E),
        foregroundColor: Colors.white,
      ),
      body: installments.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No hay cuotas para este préstamo'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final it = items[index];
              return ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text('Cuota ${it.number ?? (index + 1)}'),
                subtitle: Text([
                  if (it.amount != null) 'Monto: ${it.amount}',
                  if (it.dueDate != null) 'Vence: ${it.dueDate}',
                  if (it.status != null) 'Estado: ${it.status}',
                ].join(' · ')),
              );
            },
          );
        },
      ),
    );
  }
}

