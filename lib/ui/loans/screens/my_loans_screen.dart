import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../di/datasource_providers.dart';
import '../../../services/loans/models/loan_summary.dart';
import '../../credit-management/screens/credit_request_screen.dart';
import 'loan_detail_screen.dart';
import '../widgets/my_loans_widgets.dart';

final myLoansProvider = FutureProvider<List<LoanSummary>>((ref) async {
  return ref.watch(loansServiceProvider).myLoans();
});

class MyLoansScreen extends ConsumerWidget {
  const MyLoansScreen({super.key});

  static const _bg = Color(0xFFF6F7F8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(myLoansProvider);

    return Container(
      color: _bg,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: const BoxDecoration(color: _bg),
          child: loans.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => MyLoansErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(myLoansProvider),
            ),
            data: (items) {
              if (items.isEmpty) {
                return EmptyLoansView(
                  onNewRequest: () => context.push(CreditRequestScreen.routePath),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(myLoansProvider);
                  await ref.read(myLoansProvider.future);
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: items.length + 2,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return MyLoansPrimaryCtaButton(
                        onPressed: () => context.push(CreditRequestScreen.routePath),
                      );
                    }
                    if (index == 1) {
                      return const MyLoansSectionTitle(text: 'MIS PRÉSTAMOS ACTIVOS');
                    }

                    final loan = items[index - 2];
                    return LoanCard(
                      loan: loan,
                      onTap: () => context.push(LoanDetailScreen.routePath(loan.id)),
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
