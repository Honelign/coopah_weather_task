/// Single source of truth for all dimension values used in the app.
///
/// Covers spacing, font sizes, border radii, icon sizes, and image dimensions.
/// To change a dimension app-wide, update it here.
class AppDimensions {
  AppDimensions._();

  // -- Spacing --
  static const double spacingXs = 5.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;

  // -- Font sizes --
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 20.0;
  static const double fontSizeXl = 24.0;

  // -- Border radii --
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 30.0;

  // -- Icon sizes --
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 48.0;
  static const double iconSizeLg = 80.0;

  // -- Image dimensions --
  static const double weatherImageWidth = 250.0;
  static const double weatherImageHeight = 140.0;

  // -- Breakpoints --
  static const double compactWidthBreakpoint = 300.0;

  // -- Aspect ratios --
  /// 4:3 ratio for compact layouts.
  static const double aspectRatioCompact = 4.0 / 3.0;

  /// 16:9 ratio for wide layouts.
  static const double aspectRatioWide = 16.0 / 9.0;
}
