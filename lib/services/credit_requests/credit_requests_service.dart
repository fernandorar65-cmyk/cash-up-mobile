import '../api/api_client.dart';
import '../api/api_exception.dart';

class CreditRequestsService {
  CreditRequestsService({required ApiClient api}) : _api = api;

  final ApiClient _api;

  static const String _createPath = '/credit-requests';
  static const String _myPath = '/credit-requests/my';

  Future<Map<String, dynamic>> create({
    required num requestedAmount,
    required int termMonths,
    String? currency,
    String? purpose,
    String? clientNotes,
  }) async {
    final res = await _api.post<Map<String, dynamic>>(
      _createPath,
      data: {
        'requestedAmount': requestedAmount,
        'termMonths': termMonths,
        if (currency != null) 'currency': currency,
        if (purpose != null) 'purpose': purpose,
        if (clientNotes != null) 'clientNotes': clientNotes,
      },
    );

    final data = res.data;
    if (data == null) {
      throw ApiException(
        message: 'Respuesta vacía del servidor',
        statusCode: res.statusCode,
      );
    }
    return data;
  }

  Future<List<dynamic>> myRequests() async {
    final res = await _api.get<List<dynamic>>(_myPath);
    return res.data ?? <dynamic>[];
  }
}

