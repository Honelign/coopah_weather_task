import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/mixins/toast_mixin.dart';
import '../../domain/entities/weather_entity.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../widgets/refresh_button.dart';
import '../widgets/temperature_toggle.dart';
import '../widgets/weather_error_view.dart';
import '../widgets/weather_image.dart';
import '../widgets/weather_info_section.dart';

/// Main screen of the weather app.
///
/// Displays a weather icon, temperature, location, a Celsius/Fahrenheit toggle,
/// and a refresh button, following the provided Figma design.
///
/// Uses [ToastMixin] to show toast feedback on error states.
class WeatherPage extends StatelessWidget with ToastMixin {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<WeatherBloc, WeatherState>(
          listenWhen: (previous, current) => current is WeatherError,
          listener: (context, state) {
            if (state is WeatherError) {
              showToast(context, message: state.message, type: ToastType.error);
            }
          },
          builder: (context, state) {
            if (state is WeatherLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is WeatherError) {
              return WeatherErrorView(message: state.message);
            }
            if (state is WeatherLoaded) {
              return _buildWeatherContent(
                weather: state.weather,
                isCelsius: state.isCelsius,
              );
            }
            // WeatherInitial -- fetch is dispatched on app start,
            // so this is only visible momentarily.
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildWeatherContent({
    required WeatherEntity weather,
    required bool isCelsius,
  }) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingXl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingXl),
                const WeatherImage(),
                const SizedBox(height: AppDimensions.spacingXl),
                const Center(
                  child: Text(
                    AppStrings.appTitle,
                    style: TextStyle(
                      fontSize: AppDimensions.fontSizeXl,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXl),
                WeatherInfoSection(
                  label: AppStrings.temperatureLabel,
                  value: weather.displayTemperature(isCelsius: isCelsius),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                WeatherInfoSection(
                  label: AppStrings.locationLabel,
                  value: weather.locationName,
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                TemperatureToggle(isCelsius: isCelsius),
              ],
            ),
          ),
        ),
        const RefreshButton(),
      ],
    );
  }
}
