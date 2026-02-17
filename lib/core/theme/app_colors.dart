import 'package:flutter/material.dart';

/// Single source of truth for all color values used in the app.
///
/// These constants feed into [AppTheme] and the [ToastMixin].
/// To change a color app-wide, update it here.
class AppColors {
  AppColors._();

  // -- Brand --
  static const Color primary = Color.fromRGBO(255, 87, 0, 1);
  static const Color onPrimary = Colors.white;

  // -- Surface --
  static const Color background = Colors.white;
  static const Color surface = Colors.white;

  // -- Toast / feedback --
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  /// Foreground color used on top of all toast backgrounds.
  static const Color onToast = Colors.white;

  // -- Neutral / grey --
  static const Color imageBackground = Color(0xFFF5F5F5); // grey[100]
  static const Color iconPlaceholder = Color(0xFFBDBDBD); // grey[400]
  static const Color secondaryText = Color(0xFF757575); // grey[600]
}
