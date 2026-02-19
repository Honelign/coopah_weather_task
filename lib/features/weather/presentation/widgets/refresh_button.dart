import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';

/// A full-width button pinned at the bottom of the screen.
///
/// Dispatches [FetchWeather] to reload the weather data.
class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacingXl,
        0,
        AppDimensions.spacingXl,
        AppDimensions.spacingXl,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () =>
              context.read<WeatherBloc>().add(const FetchWeather()),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingLg,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
          ),
          child: const Text(
            AppStrings.refresh,
            style: TextStyle(fontSize: AppDimensions.fontSizeMd),
          ),
        ),
      ),
    );
  }
}
