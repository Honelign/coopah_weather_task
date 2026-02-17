import 'package:coopah_weather_task/core/utils/result.dart';
import 'package:coopah_weather_task/features/weather/domain/entities/weather_entity.dart';
import 'package:coopah_weather_task/features/weather/domain/repositories/weather_repository.dart';
import 'package:coopah_weather_task/features/weather/domain/usecases/get_weather_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetWeatherUseCase useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetWeatherUseCase(repository: mockRepository);
  });

  group('call', () {
    const tLatitude = 51.51;
    const tLongitude = -0.12;
    const tWeather = WeatherEntity(
      temperature: 297.15,
      locationName: 'London',
    );

    test('returns Success(WeatherEntity) when repository returns success',
        () async {
      when(() => mockRepository.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          )).thenAnswer((_) async => const Success(tWeather));

      final result = await useCase(
        latitude: tLatitude,
        longitude: tLongitude,
      );

      expect(result, isA<Success<WeatherEntity>>());
      result.fold(
        (weather) {
          expect(weather.temperature, 297.15);
          expect(weather.locationName, 'London');
        },
        (_) => fail('Expected Success but got Failure'),
      );
      verify(() => mockRepository.getWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          )).called(1);
    });

    test('returns Failure when repository returns failure', () async {
      when(() => mockRepository.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          )).thenAnswer((_) async => const Failure('Network error'));

      final result = await useCase(
        latitude: tLatitude,
        longitude: tLongitude,
      );

      expect(result, isA<Failure<WeatherEntity>>());
      result.fold(
        (_) => fail('Expected Failure but got Success'),
        (error) => expect(error, 'Network error'),
      );
    });
  });
}
