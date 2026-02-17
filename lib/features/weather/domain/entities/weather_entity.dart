/// Core weather entity representing weather data for a specific location.
///
/// Temperature is stored in Kelvin (the API default) and converted
/// to Celsius or Fahrenheit via computed getters.
///
class WeatherEntity {
  final double temperature;
  final String locationName;

  /// Offset to convert Kelvin to Celsius (0°C = 273.15K).
  static const double _kelvinOffset = 273.15;

  const WeatherEntity({required this.temperature, required this.locationName});

  /// Converts the stored Kelvin temperature to Celsius.
  double get temperatureInCelsius => temperature - _kelvinOffset;

  /// Converts the stored Kelvin temperature to Fahrenheit.
  double get temperatureInFahrenheit =>
      (temperature - _kelvinOffset) * 9 / 5 + 32;

  /// Returns a human-readable temperature string in the requested unit.
  ///
  /// Pass [isCelsius] `true` for Celsius, `false` for Fahrenheit.
  String displayTemperature({required bool isCelsius}) {
    final temp = isCelsius ? temperatureInCelsius : temperatureInFahrenheit;
    return '${temp.round()} degrees';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherEntity &&
          runtimeType == other.runtimeType &&
          temperature == other.temperature &&
          locationName == other.locationName;

  @override
  int get hashCode => Object.hash(temperature, locationName);
}
