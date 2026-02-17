import 'package:equatable/equatable.dart';

/// Base class for all weather-related events.
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

/// Event to trigger fetching weather data from the API.
class FetchWeather extends WeatherEvent {
  const FetchWeather();
}

/// Event to toggle between Celsius and Fahrenheit display.
///
/// The BLoC internally tracks the current unit, so no parameters are needed.
class ToggleTemperatureUnit extends WeatherEvent {
  const ToggleTemperatureUnit();
}
