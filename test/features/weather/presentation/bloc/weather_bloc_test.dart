import 'package:bloc_test/bloc_test.dart';
import 'package:coopah_weather_task/core/utils/result.dart';
import 'package:coopah_weather_task/features/weather/domain/entities/weather_entity.dart';
import 'package:coopah_weather_task/features/weather/domain/usecases/get_weather_usecase.dart';
import 'package:coopah_weather_task/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:coopah_weather_task/features/weather/presentation/bloc/weather_event.dart';
import 'package:coopah_weather_task/features/weather/presentation/bloc/weather_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetWeatherUseCase extends Mock implements GetWeatherUseCase {}

void main() {
  late WeatherBloc bloc;
  late MockGetWeatherUseCase mockGetWeather;

  setUp(() {
    mockGetWeather = MockGetWeatherUseCase();
    bloc = WeatherBloc(getWeather: mockGetWeather);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be WeatherInitial', () {
    expect(bloc.state, isA<WeatherInitial>());
  });

  group('FetchWeather', () {
    const tWeather = WeatherEntity(
      temperature: 297.15,
      locationName: 'London',
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherLoaded] when fetch is successful',
      build: () {
        when(() => mockGetWeather(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            )).thenAnswer((_) async => const Success(tWeather));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchWeather()),
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherLoaded>()
            .having((s) => s.weather, 'weather', tWeather)
            .having((s) => s.isCelsius, 'isCelsius', true),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherError] when fetch fails',
      build: () {
        when(() => mockGetWeather(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            )).thenAnswer((_) async => const Failure('Failed to fetch'));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchWeather()),
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherError>()
            .having((s) => s.message, 'message', 'Failed to fetch'),
      ],
    );
  });

  group('ToggleTemperatureUnit', () {
    const tWeather = WeatherEntity(
      temperature: 297.15,
      locationName: 'London',
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits WeatherLoaded with isCelsius=false when toggled from Celsius',
      build: () {
        when(() => mockGetWeather(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            )).thenAnswer((_) async => const Success(tWeather));
        return bloc;
      },
      act: (bloc) {
        bloc.add(const FetchWeather());
        bloc.add(const ToggleTemperatureUnit());
      },
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherLoaded>()
            .having((s) => s.isCelsius, 'isCelsius', true),
        isA<WeatherLoaded>()
            .having((s) => s.isCelsius, 'isCelsius', false),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits WeatherLoaded with isCelsius=true when toggled back from Fahrenheit',
      build: () {
        when(() => mockGetWeather(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            )).thenAnswer((_) async => const Success(tWeather));
        return bloc;
      },
      act: (bloc) {
        bloc.add(const FetchWeather());
        bloc.add(const ToggleTemperatureUnit());
        bloc.add(const ToggleTemperatureUnit());
      },
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherLoaded>()
            .having((s) => s.isCelsius, 'isCelsius', true),
        isA<WeatherLoaded>()
            .having((s) => s.isCelsius, 'isCelsius', false),
        isA<WeatherLoaded>()
            .having((s) => s.isCelsius, 'isCelsius', true),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits WeatherError when toggling without weather data',
      build: () => bloc,
      act: (bloc) => bloc.add(const ToggleTemperatureUnit()),
      expect: () => [
        isA<WeatherError>()
            .having((s) => s.message, 'message', 'No weather data available'),
      ],
    );
  });
}
