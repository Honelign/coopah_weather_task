import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized exception logging utility.
///
/// In debug mode, exceptions are pretty-printed to the console with full
/// context (caller location, optional payloads, and stack trace).
/// This class can be extended to integrate with remote error tracking
/// services (e.g., Sentry, Crashlytics) for production builds.
class ExceptionLogger {
  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void logException(
    dynamic exception, {
    required StackTrace stackTrace,
    required String callerLocation,
    Map<String, dynamic>? payloads,
  }) {
    try {
      // In a production app, this is where you'd send to Sentry/Crashlytics.
      _printForDebug(exception, stackTrace, payloads, callerLocation);
    } catch (error, stackTrace) {
      _printForDebug(
        error,
        stackTrace,
        payloads,
        'ExceptionLogger.logException',
      );
    }
  }

  /// Prints detailed exception information in debug mode only.
  static void _printForDebug(
    dynamic exception,
    StackTrace stackTrace,
    Map<String, dynamic>? payloads,
    String callerLocation,
  ) {
    if (kDebugMode) {
      try {
        _logger.e(
          {'callerLocation': callerLocation, 'payloads': ?payloads},
          error: exception,
          stackTrace: stackTrace,
        );
      } catch (e) {
        // Fallback if the logger itself fails.
        debugPrint('ExceptionLogger failed: $e');
      }
    }
  }
}
