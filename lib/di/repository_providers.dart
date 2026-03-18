import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth/auth_repository.dart';
import '../repositories/credit_requests/credit_requests_repository.dart';
import '../repositories/loans/loans_repository.dart';

import './datasource_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepository(authService: authService);
});

final creditRequestsRepositoryProvider =
    Provider<CreditRequestsRepository>((ref) {
  final service = ref.watch(creditRequestsServiceProvider);
  return CreditRequestsRepository(service: service);
});

final loansRepositoryProvider = Provider<LoansRepository>((ref) {
  final service = ref.watch(loansServiceProvider);
  return LoansRepository(service: service);
});

