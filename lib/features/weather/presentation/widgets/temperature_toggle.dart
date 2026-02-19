import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';

/// A row containing the Celsius/Fahrenheit label and a toggle switch.
///
/// Dispatches [ToggleTemperatureUnit] when the switch is tapped.
class TemperatureToggle extends StatelessWidget {
  final bool isCelsius;

  const TemperatureToggle({super.key, required this.isCelsius});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          AppStrings.celsiusFahrenheit,
          style: TextStyle(fontSize: AppDimensions.fontSizeMd),
        ),
        const SizedBox(width: AppDimensions.spacingSm),
        Switch.adaptive(
          value: !isCelsius,
          onChanged: (_) {
            context.read<WeatherBloc>().add(const ToggleTemperatureUnit());
          },
        ),
      ],
    );
  }
}
