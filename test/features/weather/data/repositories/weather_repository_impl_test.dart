import 'package:coopah_weather_task/core/exceptions.dart';
import 'package:coopah_weather_task/core/utils/result.dart';
import 'package:coopah_weather_task/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:coopah_weather_task/features/weather/data/models/weather_model.dart';
import 'package:coopah_weather_task/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockWeatherRemoteDataSource();
    repository = WeatherRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('getWeather', () {
    const tLatitude = 51.51;
    const tLongitude = -0.12;
    const tWeatherModel = WeatherModel(
      temperature: 297.15,
      locationName: 'London',
    );

    test(
        'should return Success(Weather) when the datasource call is successful',
        () async {
      // Arrange
      when(() => mockDataSource.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          )).thenAnswer((_) async => tWeatherModel);

      // Act
      final result = await repository.getWeather(
        latitude: tLatitude,
        longitude: tLongitude,
      );

      // Assert
      expect(result, isA<Success>());
      result.fold(
        (weather) {
          expect(weather.locationName, 'London');
          expect(weather.temperature, 297.15);
        },
        (error) => fail('Expected Success but got Failure'),
      );
      verify(() => mockDataSource.getWeather(
            latitude: tLatitude,
            longitude: tLongitude,
          )).called(1);
    });

    test(
        'should return Failure when the datasource throws ServerException',
        () async {
      // Arrange
      when(() => mockDataSource.getWeather(
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          )).thenThrow(const ServerException('Server error'));

      // Act
      final result = await repository.getWeather(
        latitude: tLatitude,
        longitude: tLongitude,
      );

      // Assert
      expect(result, isA<Failure>());
      result.fold(
        (_) => fail('Expected Failure but got Success'),
        (error) => expect(error, 'Server error'),
      );
    });
  });
}
