import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// Displays the weather icon inside a responsive container.
///
/// Uses a 4:3 aspect ratio when the available width is under
/// [AppDimens.compactWidthBreakpoint], and 16:9 otherwise,
/// as per the design requirements.
class WeatherImage extends StatelessWidget {
  const WeatherImage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio =
            constraints.maxWidth < AppDimens.compactWidthBreakpoint
                ? AppDimens.aspectRatioCompact
                : AppDimens.aspectRatioWide;
        return AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.imageBackground,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            ),
            child: Center(
              child: Image.asset(
                AssetConstants.weatherIcon,
                width: AppDimens.weatherImageWidth,
                height: AppDimens.weatherImageHeight,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.wb_sunny,
                    size: AppDimens.iconSizeLg,
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
