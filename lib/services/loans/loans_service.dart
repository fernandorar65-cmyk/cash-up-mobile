import '../api/api_client.dart';

import '../../models/installment.dart';
import '../../models/loan_summary.dart';

class LoansService {
  LoansService({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<List<LoanSummary>> myLoans() async {
    final res = await _api.get<List<dynamic>>('/loans/my');
    final data = res.data ?? <dynamic>[];
    return data
        .whereType<Map>()
        .map((e) => LoanSummary.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  Future<Map<String, dynamic>> loanDetail(String id) async {
    final res = await _api.get<Map<String, dynamic>>('/loans/$id');
    return res.data ?? <String, dynamic>{};
  }

  Future<List<Installment>> installments(String loanId) async {
    final res = await _api.get<List<dynamic>>('/loans/$loanId/installments');
    final data = res.data ?? <dynamic>[];
    return data
        .whereType<Map>()
        .map((e) => Installment.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}

