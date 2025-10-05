import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/services/service_provider.dart';

void main() {
  group('ServiceProvider', () {
    test('is a singleton', () {
      final instance1 = ServiceProvider();
      final instance2 = ServiceProvider();
      expect(instance1, same(instance2));
    });

    test('returns same instance from factory constructor', () {
      final instance1 = ServiceProvider();
      final instance2 = ServiceProvider();
      expect(identical(instance1, instance2), isTrue);
    });

    test('extends ChangeNotifier', () {
      final provider = ServiceProvider();
      expect(provider, isA<ChangeNotifier>());
    });

    test('can add and remove listeners', () {
      final provider = ServiceProvider();
      void listener() {}

      provider.addListener(listener);
      provider.removeListener(listener);
      // If no exception, test passes
    });

    // Note: Testing the actual initialization and service getters would require
    // initializing Firebase, which is complex in unit tests. These tests would be
    // better suited for integration tests. The critical singleton behavior is
    // verified above.
  });
}
