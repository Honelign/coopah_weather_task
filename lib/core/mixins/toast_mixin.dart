import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

/// The type of toast message to display.
///
/// Each type maps to a distinct background color and leading icon
/// for quick visual identification.
enum ToastType { success, error, warning, info }

/// A mixin that provides a [showToast] method for displaying
/// themed [SnackBar] messages.
///
/// Usage — mix it into any widget class:
/// ```dart
/// class MyPage extends StatelessWidget with ToastMixin { ... }
/// ```
/// Then call:
/// ```dart
/// showToast(context, message: 'Saved!', type: ToastType.success);
/// ```
mixin ToastMixin {
  /// Displays a floating [SnackBar] styled according to [type].
  void showToast(
    BuildContext context, {
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _colorForType(type),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          duration: duration,
          content: Row(
            children: [
              Icon(
                _iconForType(type),
                color: AppColors.onToast,
                size: AppDimensions.iconSizeSm,
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: AppColors.onToast),
                ),
              ),
            ],
          ),
        ),
      );
  }

  /// Returns the appropriate icon for each [ToastType].
  IconData _iconForType(ToastType type) {
    return switch (type) {
      ToastType.success => Icons.check_circle_outline,
      ToastType.error => Icons.error_outline,
      ToastType.warning => Icons.warning_amber_rounded,
      ToastType.info => Icons.info_outline,
    };
  }

  /// Returns the background color for each [ToastType] from [AppColors].
  Color _colorForType(ToastType type) {
    return switch (type) {
      ToastType.success => AppColors.success,
      ToastType.error => AppColors.error,
      ToastType.warning => AppColors.warning,
      ToastType.info => AppColors.info,
    };
  }
}
