/// Centralized string constants for the app.
///
/// Keeps all user-facing and static strings in one place for consistency
/// and easier i18n later.
class AppStrings {
  AppStrings._();

  // -- App title --
  static const String appTitle = 'THIS IS MY WEATHER APP';

  // -- Weather labels --
  static const String temperatureLabel = 'Temperature';
  static const String locationLabel = 'Location';
  static const String celsiusFahrenheit = 'Celsius/Fahrenheit';

  // -- Buttons --
  static const String refresh = 'Refresh';
  static const String retry = 'Retry';

  // -- Error / config --
  static const String envConfigError =
      'Configuration error: file is missing or corrupted.';
}
