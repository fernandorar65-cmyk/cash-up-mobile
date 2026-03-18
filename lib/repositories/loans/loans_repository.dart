import '../../models/installment.dart';
import '../../models/loan_summary.dart';
import '../../services/loans/loans_service.dart';

class LoansRepository {
  LoansRepository({required LoansService service}) : _service = service;

  final LoansService _service;

  Future<List<LoanSummary>> myLoans() {
    return _service.myLoans();
  }

  Future<Map<String, dynamic>> loanDetail(String id) {
    return _service.loanDetail(id);
  }

  Future<List<Installment>> installments(String loanId) {
    return _service.installments(loanId);
  }
}

