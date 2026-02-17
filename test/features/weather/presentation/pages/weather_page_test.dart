import 'package:bloc_test/bloc_test.dart';
import 'package:coopah_weather_task/core/constants/app_strings.dart';
import 'package:coopah_weather_task/core/theme/app_theme.dart';
import 'package:coopah_weather_task/features/weather/domain/entities/weather_entity.dart';
import 'package:coopah_weather_task/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:coopah_weather_task/features/weather/presentation/bloc/weather_event.dart';
import 'package:coopah_weather_task/features/weather/presentation/bloc/weather_state.dart';
import 'package:coopah_weather_task/features/weather/presentation/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockBloc;

  const tWeather = WeatherEntity(
    temperature: 297.15,
    locationName: 'London',
  );

  setUpAll(() {
    registerFallbackValue(const FetchWeather());
  });

  setUp(() {
    mockBloc = MockWeatherBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.light,
      home: BlocProvider<WeatherBloc>.value(
        value: mockBloc,
        child: const WeatherPage(),
      ),
    );
  }

  group('WeatherPage', () {
    testWidgets('displays loading indicator when state is WeatherLoading',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const WeatherLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays weather data when state is WeatherLoaded',
        (tester) async {
      when(() => mockBloc.state).thenReturn(
        const WeatherLoaded(weather: tWeather, isCelsius: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(AppStrings.appTitle), findsOneWidget);
      expect(find.text(AppStrings.temperatureLabel), findsOneWidget);
      expect(find.text('24 degrees'), findsOneWidget);
      expect(find.text(AppStrings.locationLabel), findsOneWidget);
      expect(find.text('London'), findsOneWidget);
      expect(find.text(AppStrings.celsiusFahrenheit), findsOneWidget);
      expect(find.text(AppStrings.refresh), findsOneWidget);
    });

    testWidgets('displays error message when state is WeatherError',
        (tester) async {
      when(() => mockBloc.state).thenReturn(
        const WeatherError(message: 'Server error'),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('shows error toast when WeatherError state is emitted',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const WeatherLoading());
      whenListen(
        mockBloc,
        Stream<WeatherState>.fromIterable([
          const WeatherError(message: 'Connection failed'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Connection failed'), findsWidgets);
      // One in the WeatherErrorView, one in the toast SnackBar.
      expect(find.byIcon(Icons.error_outline), findsNWidgets(2));
    });

    testWidgets('tapping Refresh button dispatches FetchWeather event',
        (tester) async {
      when(() => mockBloc.state).thenReturn(
        const WeatherLoaded(weather: tWeather, isCelsius: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text(AppStrings.refresh));

      final captured =
          verify(() => mockBloc.add(captureAny())).captured.single;
      expect(captured, isA<FetchWeather>());
    });

    testWidgets('tapping Switch dispatches ToggleTemperatureUnit event',
        (tester) async {
      when(() => mockBloc.state).thenReturn(
        const WeatherLoaded(weather: tWeather, isCelsius: true),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.ensureVisible(find.byType(Switch));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch));

      final captured =
          verify(() => mockBloc.add(captureAny())).captured.single;
      expect(captured, isA<ToggleTemperatureUnit>());
    });
  });
}
