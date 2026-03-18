import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../di/datasource_providers.dart';
import '../../../services/loans/models/loan_summary.dart';
import '../../credit-management/screens/credit_request_screen.dart';
import 'loan_detail_screen.dart';

final myLoansProvider = FutureProvider<List<LoanSummary>>((ref) async {
  return ref.watch(loansServiceProvider).myLoans();
});

class MyLoansScreen extends ConsumerWidget {
  const MyLoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(myLoansProvider);

    return Container(
      color: const Color(0xFFF6F7F8),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: const BoxDecoration(color: Colors.white),
          child: loans.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(myLoansProvider),
            ),
            data: (items) {
              if (items.isEmpty) {
                return _EmptyLoansView(
                  onNewRequest: () => context.push(CreditRequestScreen.routePath),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(myLoansProvider);
                  await ref.read(myLoansProvider.future);
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push(CreditRequestScreen.routePath),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A202E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Solicitar un crédito'),
                        ),
                      );
                    }

                    final loan = items[index - 1];
                    return ListTile(
                      tileColor: const Color(0xFFF8FAFC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      title: Text('Préstamo #${loan.id}'),
                      subtitle: Text([
                        if (loan.amount != null) 'Monto: ${loan.amount}',
                        if (loan.currency != null) 'Moneda: ${loan.currency}',
                        if (loan.status != null) 'Estado: ${loan.status}',
                      ].join(' · ')),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(
                        LoanDetailScreen.routePath(loan.id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyLoansView extends StatelessWidget {
  const _EmptyLoansView({required this.onNewRequest});

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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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

