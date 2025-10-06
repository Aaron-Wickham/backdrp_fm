import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Application-wide logger instance
///
/// Usage:
/// ```dart
/// AppLogger.debug('Debug message');
/// AppLogger.info('Info message');
/// AppLogger.warning('Warning message');
/// AppLogger.error('Error message', error: e, stackTrace: st);
/// ```
class AppLogger {
  static final Logger _logger = Logger(
    filter: _AppLogFilter(),
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to display
      errorMethodCount: 8, // Number of method calls for errors
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print emoji for each log message
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: _AppLogOutput(),
  );

  /// Debug log - Use for debugging information during development
  static void debug(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Info log - Use for general information about app flow
  static void info(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning log - Use for potentially harmful situations
  static void warning(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error log - Use for error events
  static void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Fatal log - Use for very severe error events
  static void fatal(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Trace log - Use for more fine-grained informational events
  static void trace(dynamic message, {Object? error, StackTrace? stackTrace}) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }
}

/// Custom log filter that only logs in debug mode
class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // Only log in debug mode
    return kDebugMode;
  }
}

/// Custom log output
class _AppLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // In debug mode, print to console
    if (kDebugMode) {
      for (var line in event.lines) {
        // ignore: avoid_print
        print(line);
      }
    }

    // In production, you could send logs to a service like Sentry or Firebase Crashlytics
    // Example:
    // if (!kDebugMode && event.level.index >= Level.error.index) {
    //   FirebaseCrashlytics.instance.log(event.lines.join('\n'));
    // }
  }
}
