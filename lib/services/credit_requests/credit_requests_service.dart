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
    final payload = <String, dynamic>{
      'requestedAmount': requestedAmount,
      'termMonths': termMonths,
    };
    if (currency != null) payload['currency'] = currency;
    if (purpose != null) payload['purpose'] = purpose;
    if (clientNotes != null) payload['clientNotes'] = clientNotes;

    final res = await _api.post<Map<String, dynamic>>(
      _createPath,
      data: {...payload},
    );

    final data = res.data;
    return data ?? (throw ApiException(
      message: 'Respuesta vacía del servidor',
      statusCode: res.statusCode,
    ));
  }

  Future<List<dynamic>> myRequests() async {
    final res = await _api.get<List<dynamic>>(_myPath);
    return res.data ?? <dynamic>[];
  }
}

