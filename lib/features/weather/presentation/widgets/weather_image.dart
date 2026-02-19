import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// Displays the weather icon inside a responsive container.
///
/// Uses a 4:3 aspect ratio when the available width is under
/// [AppDimensions.compactWidthBreakpoint], and 16:9 otherwise,
/// as per the design requirements.
class WeatherImage extends StatelessWidget {
  const WeatherImage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio =
            constraints.maxWidth < AppDimensions.compactWidthBreakpoint
            ? AppDimensions.aspectRatioCompact
            : AppDimensions.aspectRatioWide;
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.imageBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Center(
              child: Image.asset(
                AssetConstants.weatherIcon,
                width: AppDimensions.weatherImageWidth,
                height: AppDimensions.weatherImageHeight,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.wb_sunny,
                    size: AppDimensions.iconSizeLg,
                    color: AppColors.iconPlaceholder,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
