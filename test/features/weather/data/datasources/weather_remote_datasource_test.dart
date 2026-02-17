import 'package:coopah_weather_task/core/exceptions.dart';
import 'package:coopah_weather_task/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:coopah_weather_task/features/weather/data/models/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late WeatherRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = WeatherRemoteDataSourceImpl(
      dio: mockDio,
      apiKey: 'test_api_key',
    );
  });

  group('getWeather', () {
    const tLatitude = 51.51494225418024;
    const tLongitude = -0.12363193061883422;

    final tWeatherJson = {
      'main': {'temp': 297.15},
      'name': 'London',
    };

    test('should return WeatherModel when the response code is 200', () async {
      // Arrange
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: tWeatherJson,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // Act
      final result = await dataSource.getWeather(
        latitude: tLatitude,
        longitude: tLongitude,
      );

      // Assert
      expect(result, isA<WeatherModel>());
      expect(result.temperature, 297.15);
      expect(result.locationName, 'London');
    });

    test('should throw ServerException when Dio throws DioException', () async {
      // Arrange
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            statusMessage: 'Not Found',
            requestOptions: RequestOptions(),
          ),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.getWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException with parse message when response JSON is malformed', () async {
      // Arrange
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          data: {'unexpected': 'schema'},
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.getWeather(
          latitude: tLatitude,
          longitude: tLongitude,
        ),
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            'Failed to parse weather data',
          ),
        ),
      );
    });
  });
}
