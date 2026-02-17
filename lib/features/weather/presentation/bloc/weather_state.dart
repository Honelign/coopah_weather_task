import 'package:equatable/equatable.dart';

import '../../domain/entities/weather_entity.dart';

/// Base class for all weather-related states.
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any weather data has been requested.
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

/// State indicating weather data is currently being fetched.
class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

/// State indicating weather data was successfully loaded.
///
/// [isCelsius] controls the displayed temperature unit.
class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;
  final bool isCelsius;

  const WeatherLoaded({
    required this.weather,
    required this.isCelsius,
  });

  @override
  List<Object?> get props => [weather, isCelsius];
}

/// State indicating an error occurred while fetching weather data.
class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message});

  @override
  List<Object?> get props => [message];
}
