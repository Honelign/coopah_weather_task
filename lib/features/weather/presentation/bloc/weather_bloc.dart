import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/exception_logger.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/get_weather_usecase.dart';
import 'weather_event.dart';
import 'weather_state.dart';

/// BLoC responsible for managing the weather feature state.
///
/// Handles [FetchWeather] events by calling [GetWeatherUseCase] with the
/// predefined London coordinates, and [ToggleTemperatureUnit] events
/// by toggling between Celsius and Fahrenheit.
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherUseCase getWeather;
  WeatherEntity? _weather;
  bool _isCelsius = true;

  WeatherBloc({required this.getWeather}) : super(const WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
    on<ToggleTemperatureUnit>(_onToggleTemperatureUnit);
  }

  /// Fetches weather data and emits the appropriate state.
  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      emit(const WeatherLoading());

      final result = await getWeather(
        latitude: ApiConstants.latitude,
        longitude: ApiConstants.longitude,
      );

      result.fold((weather) {
        _weather = weather;
        _isCelsius = true;
        emit(WeatherLoaded(weather: _weather!, isCelsius: _isCelsius));
      }, (error) => emit(WeatherError(message: error)));
    } catch (error, stackTrace) {
      ExceptionLogger.logException(
        error,
        stackTrace: stackTrace,
        callerLocation: 'WeatherBloc._onFetchWeather',
      );
      emit(const WeatherError(message: 'An unexpected error occurred'));
    }
  }

  /// Toggles the temperature unit only if weather data is currently loaded.
  void _onToggleTemperatureUnit(
    ToggleTemperatureUnit event,
    Emitter<WeatherState> emit,
  ) {
    try {
      if (_weather == null) {
        emit(const WeatherError(message: 'No weather data available'));
        return;
      }
      _isCelsius = !_isCelsius;
      emit(WeatherLoaded(weather: _weather!, isCelsius: _isCelsius));
    } catch (error, stackTrace) {
      ExceptionLogger.logException(
        error,
        stackTrace: stackTrace,
        callerLocation: 'WeatherBloc._onToggleTemperatureUnit',
      );
      emit(const WeatherError(message: 'Failed to toggle temperature unit'));
    }
  }
}
