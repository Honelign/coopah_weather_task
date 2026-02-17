/// Constant keys for environment variables loaded from `.env`.
///
/// Centralises the raw strings so a typo is caught at compile-time
/// rather than silently returning `null` from `dotenv.env[...]`.
class EnvKeys {
  EnvKeys._();

  static const String openWeatherApiKey = 'OPEN_WEATHER_API_KEY';
}
