import '../../domain/entities/weather_entity.dart';

/// Data model that maps the OpenWeatherMap API JSON response to a [WeatherEntity].
///
/// Extends [WeatherEntity] to maintain separation between the data and domain
/// layers while providing JSON deserialization capability.
/// Parsing errors are caught and logged by the datasource layer.
class WeatherModel extends WeatherEntity {
  const WeatherModel({required super.temperature, required super.locationName});

  /// Creates a [WeatherModel] from the OpenWeatherMap API JSON response.
  ///
  /// Expected JSON structure:
  /// ```json
  /// {
  ///   "main": { "temp": 297.15 },
  ///   "name": "London"
  /// }
  /// ```
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: (json['main']['temp'] as num).toDouble(),
      locationName: json['name'] as String,
    );
  }
}
