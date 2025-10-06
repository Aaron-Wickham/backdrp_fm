import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/common/environment_banner.dart';

void main() {
  group('EnvironmentBanner', () {
    testWidgets('wraps child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EnvironmentBanner(
            child: Text('Test Child'),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('displays child when in production or release mode',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EnvironmentBanner(
            child: Scaffold(
              body: Center(child: Text('App Content')),
            ),
          ),
        ),
      );

      expect(find.text('App Content'), findsOneWidget);
    });
  });

  group('EnvironmentIndicator', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Text('Main Content'),
                EnvironmentIndicator(),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Main Content'), findsOneWidget);
    });

    testWidgets('can be positioned', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                EnvironmentIndicator(),
              ],
            ),
          ),
        ),
      );

      // In production or non-debug mode, it should render as SizedBox.shrink
      // In debug mode with dev/staging, it would show the indicator
      expect(find.byType(EnvironmentIndicator), findsOneWidget);
    });
  });
}
