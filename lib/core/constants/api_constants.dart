/// Centralized API configuration constants.
///
/// Keeps all API-related values in one place for easy maintenance.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the OpenWeatherMap API.
  ///
  /// Configured on Dio's [BaseOptions] in the injection container,
  /// so datasources only need to reference the endpoint path.
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Endpoint path appended to [baseUrl] by Dio.
  static const String weatherEndpoint = '/weather';

  /// London coordinates as specified in the task requirements.
  static const double latitude = 51.51494225418024;
  static const double longitude = -0.12363193061883422;
}
