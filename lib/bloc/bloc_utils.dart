import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

/// Utility class for common BLoC patterns and transformers
class BlocUtils {
  BlocUtils._();

  /// Debounce transformer - useful for search inputs
  /// Waits for [duration] of inactivity before processing event
  static EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) {
      return events.debounceTime(duration).asyncExpand(mapper);
    };
  }

  /// Throttle transformer - useful for pagination and scroll events
  /// Processes first event, then ignores subsequent events for [duration]
  static EventTransformer<T> throttle<T>(Duration duration) {
    return (events, mapper) {
      return events.throttleTime(duration).asyncExpand(mapper);
    };
  }

  /// Sequential transformer - processes events one at a time
  /// Waits for previous event to complete before processing next
  static EventTransformer<T> sequential<T>() {
    return (events, mapper) {
      return events.asyncExpand(mapper);
    };
  }

  /// Concurrent transformer - processes events concurrently
  /// Multiple events can be processed at the same time
  static EventTransformer<T> concurrent<T>() {
    return (events, mapper) {
      return events.flatMap(mapper);
    };
  }

  /// Restartable transformer - cancels previous event processing when new event arrives
  /// Useful for API calls that should be cancelled if a new request comes in
  static EventTransformer<T> restartable<T>() {
    return (events, mapper) {
      return events.switchMap(mapper);
    };
  }

  /// Handle errors in BLoC event handlers
  static Future<void> handleError(
    Object error,
    StackTrace stackTrace,
    Function(String) emitError,
  ) async {
    if (kDebugMode) {
      print('BLoC Error: $error');
      print('StackTrace: $stackTrace');
    }

    String errorMessage = 'An unexpected error occurred';

    if (error is TimeoutException) {
      errorMessage = 'Request timed out. Please try again.';
    } else if (error is FormatException) {
      errorMessage = 'Invalid data format';
    } else if (error.toString().contains('network')) {
      errorMessage = 'Network error. Please check your connection.';
    }

    emitError(errorMessage);
  }
}

/// Extension on Stream for debouncing
extension DebounceExtension<T> on Stream<T> {
  Stream<T> debounceTime(Duration duration) {
    StreamController<T>? controller;
    Timer? timer;
    StreamSubscription<T>? subscription;

    void onData(T data) {
      timer?.cancel();
      timer = Timer(duration, () {
        controller?.add(data);
      });
    }

    controller = StreamController<T>(
      onListen: () {
        subscription = listen(
          onData,
          onError: controller!.addError,
          onDone: () {
            timer?.cancel();
            controller!.close();
          },
        );
      },
      onCancel: () {
        timer?.cancel();
        subscription?.cancel();
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
    );

    return controller.stream;
  }

  /// Throttle stream - emits first item, then ignores items for duration
  Stream<T> throttleTime(Duration duration) {
    StreamController<T>? controller;
    Timer? timer;
    StreamSubscription<T>? subscription;
    bool isThrottling = false;

    void onData(T data) {
      if (!isThrottling) {
        controller?.add(data);
        isThrottling = true;
        timer = Timer(duration, () {
          isThrottling = false;
        });
      }
    }

    controller = StreamController<T>(
      onListen: () {
        subscription = listen(
          onData,
          onError: controller!.addError,
          onDone: () {
            timer?.cancel();
            controller!.close();
          },
        );
      },
      onCancel: () {
        timer?.cancel();
        subscription?.cancel();
      },
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
    );

    return controller.stream;
  }

  /// Switch to latest stream - cancels previous when new arrives
  Stream<S> switchMap<S>(Stream<S> Function(T) mapper) {
    StreamController<S>? controller;
    StreamSubscription<T>? subscription;
    StreamSubscription<S>? innerSubscription;

    void onData(T data) async {
      await innerSubscription?.cancel();
      innerSubscription = mapper(
        data,
      ).listen(controller!.add, onError: controller.addError);
    }

    controller = StreamController<S>(
      onListen: () {
        subscription = listen(
          onData,
          onError: controller!.addError,
          onDone: () async {
            await innerSubscription?.cancel();
            controller!.close();
          },
        );
      },
      onCancel: () async {
        await innerSubscription?.cancel();
        await subscription?.cancel();
      },
      onPause: () {
        subscription?.pause();
        innerSubscription?.pause();
      },
      onResume: () {
        subscription?.resume();
        innerSubscription?.resume();
      },
    );

    return controller.stream;
  }

  /// Flat map - processes all streams concurrently
  Stream<S> flatMap<S>(Stream<S> Function(T) mapper) {
    StreamController<S>? controller;
    StreamSubscription<T>? subscription;
    final List<StreamSubscription<S>> innerSubscriptions = [];
    int activeSubscriptions = 0;
    bool isDone = false;

    void checkClose() {
      if (isDone && activeSubscriptions == 0) {
        controller?.close();
      }
    }

    void onData(T data) {
      activeSubscriptions++;
      final innerSubscription = mapper(data).listen(
        controller!.add,
        onError: controller.addError,
        onDone: () {
          activeSubscriptions--;
          checkClose();
        },
      );
      innerSubscriptions.add(innerSubscription);
    }

    controller = StreamController<S>(
      onListen: () {
        subscription = listen(
          onData,
          onError: controller!.addError,
          onDone: () {
            isDone = true;
            checkClose();
          },
        );
      },
      onCancel: () async {
        await subscription?.cancel();
        for (final sub in innerSubscriptions) {
          await sub.cancel();
        }
      },
      onPause: () {
        subscription?.pause();
        for (final sub in innerSubscriptions) {
          sub.pause();
        }
      },
      onResume: () {
        subscription?.resume();
        for (final sub in innerSubscriptions) {
          sub.resume();
        }
      },
    );

    return controller.stream;
  }
}

/// Extension on Bloc for common patterns
extension BlocExtensions<Event, State> on Bloc<Event, State> {
  /// Add event with error handling
  void addSafe(Event event) {
    try {
      add(event);
    } catch (e) {
      if (kDebugMode) {
        print('Error adding event: $e');
      }
    }
  }

  /// Add event after delay
  Future<void> addDelayed(Event event, Duration delay) async {
    await Future.delayed(delay);
    if (!isClosed) {
      add(event);
    }
  }

  /// Add multiple events
  void addAll(List<Event> events) {
    for (final event in events) {
      add(event);
    }
  }
}

/// Retry utility for async operations
class RetryUtil {
  /// Retry an async operation with exponential backoff
  static Future<T> retry<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffFactor = 2.0,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        if (attempt >= maxAttempts) {
          rethrow;
        }

        if (kDebugMode) {
          print('Retry attempt $attempt after error: $e');
        }

        await Future.delayed(delay);
        delay *= backoffFactor;
      }
    }
  }
}
