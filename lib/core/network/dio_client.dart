import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';

/// Creates and configures the Dio HTTP client used for API requests.
///
/// Keeps network configuration (base URL, timeouts, interceptors) separate
/// from dependency wiring. The injection container registers this instance.
class DioClient {
  DioClient._();

  /// Returns a configured [Dio] instance for the OpenWeatherMap API.
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }
}
