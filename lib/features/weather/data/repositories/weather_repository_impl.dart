import '../../../../core/exceptions.dart';
import '../../../../core/utils/exception_logger.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_datasource.dart';

/// Concrete implementation of [WeatherRepository].
///
/// Delegates data fetching to [WeatherRemoteDataSource] and translates
/// data-layer exceptions into domain-friendly [Result] objects.
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  const WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<WeatherEntity>> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final weather = await remoteDataSource.getWeather(
        latitude: latitude,
        longitude: longitude,
      );
      return Success(weather);
    } on ServerException catch (e) {
      // Already logged by datasource — convert to Failure only.
      return Failure(e.message);
    } catch (error, stackTrace) {
      ExceptionLogger.logException(
        error,
        stackTrace: stackTrace,
        callerLocation: 'WeatherRepositoryImpl.getWeather',
      );
      return const Failure('An unexpected error occurred');
    }
  }
}
