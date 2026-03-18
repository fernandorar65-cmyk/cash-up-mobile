import '../../services/credit_requests/credit_requests_service.dart';

class CreditRequestsRepository {
  CreditRequestsRepository({required CreditRequestsService service})
      : _service = service;

  final CreditRequestsService _service;

  Future<Map<String, dynamic>> create({
    required num requestedAmount,
    required int termMonths,
    String? currency,
    String? purpose,
    String? clientNotes,
  }) {
    return _service.create(
      requestedAmount: requestedAmount,
      termMonths: termMonths,
      currency: currency,
      purpose: purpose,
      clientNotes: clientNotes,
    );
  }

  Future<List<dynamic>> myRequests() {
    return _service.myRequests();
  }
}

