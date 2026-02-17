import '../../../../core/utils/result.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

/// Fetches the current weather for a given location.
///
/// This use case sits between the presentation and data layers,
/// ensuring the BLoC never depends on the repository directly.
/// Any business rules applied before or after the fetch belong here.
class GetWeatherUseCase {
  final WeatherRepository _repository;

  const GetWeatherUseCase({required WeatherRepository repository})
      : _repository = repository;

  /// Executes the use case for the given [latitude] and [longitude].
  ///
  /// Returns a [Result] wrapping either a [WeatherEntity] on success
  /// or an error message string on failure.
  Future<Result<WeatherEntity>> call({
    required double latitude,
    required double longitude,
  }) {
    return _repository.getWeather(latitude: latitude, longitude: longitude);
  }
}
