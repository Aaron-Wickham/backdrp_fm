import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/common/error_view.dart';
import 'package:backdrp_fm/widgets/buttons/primary_button.dart';

void main() {
  group('ErrorView', () {
    testWidgets('displays error title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Something went wrong',
            ),
          ),
        ),
      );

      expect(find.text('ERROR'), findsOneWidget);
    });

    testWidgets('displays error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Something went wrong',
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('displays default error icon when not specified',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Something went wrong',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('displays custom error icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Network error',
              icon: Icons.wifi_off,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('displays retry button when onRetry is provided',
        (tester) async {
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Something went wrong',
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('RETRY'), findsOneWidget);

      await tester.tap(find.byType(PrimaryButton));
      expect(retryCalled, isTrue);
    });

    testWidgets('does not display retry button when onRetry is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Something went wrong',
            ),
          ),
        ),
      );

      expect(find.byType(PrimaryButton), findsNothing);
    });

    testWidgets('content is centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Something went wrong',
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });

    testWidgets('displays all elements in correct order', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Failed to load data',
              icon: Icons.cloud_off,
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(find.text('ERROR'), findsOneWidget);
      expect(find.text('Failed to load data'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('displays column layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Something went wrong',
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });
  });
}
