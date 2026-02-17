import '../../../../core/utils/result.dart';
import '../entities/weather_entity.dart';

/// Contract for weather data retrieval.
///
/// Returns a [Result] wrapping either a [WeatherEntity] on success
/// or an error message on failure, allowing the presentation layer
/// to handle both cases without catching exceptions.
abstract class WeatherRepository {
  /// Fetches current weather data for the given [latitude] and [longitude].
  Future<Result<WeatherEntity>> getWeather({
    required double latitude,
    required double longitude,
  });
}
