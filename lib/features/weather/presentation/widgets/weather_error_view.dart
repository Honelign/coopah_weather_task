import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';

/// Displays an error icon, message, and retry button.
///
/// Styled consistently with the app's error feedback (same icon and color
/// as [ToastMixin] error toasts).
class WeatherErrorView extends StatelessWidget {
  final String message;

  const WeatherErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: AppDimensions.iconSizeMd,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppDimensions.fontSizeMd,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            ElevatedButton(
              onPressed: () =>
                  context.read<WeatherBloc>().add(const FetchWeather()),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
