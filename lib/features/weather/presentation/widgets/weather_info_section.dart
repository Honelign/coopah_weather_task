import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';

/// Displays a labelled weather field (e.g. Temperature, Location).
///
/// Keeps the label/value pattern consistent and reusable.
class WeatherInfoSection extends StatelessWidget {
  final String label;
  final String value;

  const WeatherInfoSection({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeLg,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeMd,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
