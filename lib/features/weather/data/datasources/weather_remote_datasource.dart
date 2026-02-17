import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions.dart';
import '../../../../core/utils/exception_logger.dart';
import '../models/weather_model.dart';

/// Contract for fetching weather data from the remote API.
abstract class WeatherRemoteDataSource {
  /// Calls the OpenWeatherMap API and returns a [WeatherModel].
  ///
  /// Throws a [ServerException] if the request fails.
  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  });
}

/// Implementation of [WeatherRemoteDataSource] using Dio.
///
/// The [apiKey] is injected at construction time so that callers
/// (e.g., the repository) never need to know about API authentication.
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;
  final String apiKey;

  WeatherRemoteDataSourceImpl({required this.dio, required this.apiKey});

  @override
  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.weatherEndpoint,
        queryParameters: {'lat': latitude, 'lon': longitude, 'appid': apiKey},
      );

      return _parseResponse(response.data);
    } on DioException catch (error, stackTrace) {
      ExceptionLogger.logException(
        error,
        stackTrace: stackTrace,
        callerLocation: 'WeatherRemoteDataSourceImpl.getWeather',
        payloads: {'latitude': latitude, 'longitude': longitude},
      );
      throw ServerException(
        error.response?.statusMessage ?? 'Failed to fetch weather data',
      );
    } on ServerException {
      // Thrown by _parseResponse — let it propagate with its specific message.
      rethrow;
    } catch (error, stackTrace) {
      ExceptionLogger.logException(
        error,
        stackTrace: stackTrace,
        callerLocation: 'WeatherRemoteDataSourceImpl.getWeather',
      );
      throw const ServerException('An unexpected error occurred');
    }
  }

  /// Parses the raw API response into a [WeatherModel].
  ///
  /// Separated from the network call so that parsing failures produce
  /// a clear, specific error message instead of a generic one.
  WeatherModel _parseResponse(dynamic data) {
    try {
      return WeatherModel.fromJson(data as Map<String, dynamic>);
    } catch (error, stackTrace) {
      ExceptionLogger.logException(
        error,
        stackTrace: stackTrace,
        callerLocation: 'WeatherRemoteDataSourceImpl._parseResponse',
        payloads: {'data': data.toString()},
      );
      throw const ServerException('Failed to parse weather data');
    }
  }
}
