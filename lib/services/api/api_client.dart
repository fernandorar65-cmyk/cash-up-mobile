import 'package:dio/dio.dart';

import '../../core/prefs/user_prefs.dart';
import 'api_exception.dart';
import 'app_config.dart';

class ApiClient {
  ApiClient({
    required UserPrefs userPrefs,
    this.onUnauthorized,
    Dio? dio,
  })  : _userPrefs = userPrefs,
        dio = dio ?? Dio() {
    this.dio.options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    this.dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _userPrefs.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          await _handleError(error, handler);
        },
      ),
    );
  }

  final Future<void> Function()? onUnauthorized;
  final UserPrefs _userPrefs;
  final Dio dio;

  Future<void>? _refreshingFuture;

  Future<void> _handleError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = error.response?.statusCode;
    final requestOptions = error.requestOptions;
    final extra = requestOptions.extra;
    final skipRefresh = extra['skipRefresh'] == true;
    final alreadyRetried = extra['retried'] == true;

    if (statusCode == 401 && !skipRefresh && !alreadyRetried) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        final newToken = await _userPrefs.getAccessToken();
        final retryExtra = <String, dynamic>{...extra, 'retried': true};
        final headers = Map<String, dynamic>.from(requestOptions.headers);
        if (newToken != null && newToken.isNotEmpty) {
          headers['Authorization'] = 'Bearer $newToken';
        }

        final opts = Options(
          method: requestOptions.method,
          headers: headers,
          responseType: requestOptions.responseType,
          contentType: requestOptions.contentType,
          followRedirects: requestOptions.followRedirects,
          receiveDataWhenStatusError:
              requestOptions.receiveDataWhenStatusError,
          extra: retryExtra,
        );

        try {
          final retryResponse = await dio.request<dynamic>(
            requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: opts,
            cancelToken: requestOptions.cancelToken,
          );
          handler.resolve(retryResponse);
          return;
        } catch (_) {
        }
      }
    }

    if (statusCode == 401 || skipRefresh || alreadyRetried) {
      await _logoutAndRedirect();
    }

    handler.reject(error);
  }

  Future<bool> _tryRefresh() async {
    if (_refreshingFuture != null) {
      await _refreshingFuture;
      final t = await _userPrefs.getAccessToken();
      return t != null && t.isNotEmpty;
    }

    _refreshingFuture = () async {
      try {
        final oldToken = await _userPrefs.getAccessToken();
        if (oldToken == null || oldToken.isEmpty) return;

        final res = await dio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: {'access_token': oldToken},
          options: Options(extra: {'skipRefresh': true}),
        );

        final data = res.data;
        if (data == null) return;

        final newToken = data['access_token'] ??
            data['accessToken'] ??
            data['token'];
        if (newToken is String && newToken.isNotEmpty) {
          await _userPrefs.saveAccessToken(newToken);
        }
      } catch (_) {
        // fallo silencioso: se manejará en el flujo de logout
      }
    }();

    await _refreshingFuture;
    _refreshingFuture = null;

    final token = await _userPrefs.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _logoutAndRedirect() async {
    await _userPrefs.clearSession();
    if (onUnauthorized != null) {
      await onUnauthorized!.call();
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

