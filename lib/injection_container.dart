import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'core/constants/env_keys.dart';
import 'core/network/dio_client.dart';
import 'features/weather/data/datasources/weather_remote_datasource.dart';
import 'features/weather/data/repositories/weather_repository_impl.dart';
import 'features/weather/domain/repositories/weather_repository.dart';
import 'features/weather/domain/usecases/get_weather_usecase.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Registers all dependencies in the service locator.
///
/// Call this once during app startup, after loading environment variables.
/// Dependencies are registered bottom-up: external libs -> data layer ->
/// domain layer -> presentation layer.
void initDependencies() {
  // -- External --
  sl.registerLazySingleton<Dio>(() => DioClient.create());

  // -- Data layer --
  // The API key is injected here so the repository layer stays
  // unaware of authentication details.
  final apiKey = dotenv.env[EnvKeys.openWeatherApiKey];
  if (apiKey == null || apiKey.isEmpty) {
    throw StateError(
      'OPEN_WEATHER_API_KEY is missing from .env. '
      'Ensure the .env file exists and contains the key.',
    );
  }

  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      dio: sl<Dio>(),
      apiKey: apiKey,
    ),
  );

  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl<WeatherRemoteDataSource>(),
    ),
  );

  // -- Domain layer --
  sl.registerLazySingleton<GetWeatherUseCase>(
    () => GetWeatherUseCase(repository: sl<WeatherRepository>()),
  );

  // -- Presentation layer --
  // Registered as a factory so a fresh BLoC is created each time.
  sl.registerFactory<WeatherBloc>(
    () => WeatherBloc(getWeather: sl<GetWeatherUseCase>()),
  );
}
