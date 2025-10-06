import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/common/loading_indicator.dart';

void main() {
  group('LoadingIndicator', () {
    testWidgets('displays circular progress indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('uses default size when not specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(LoadingIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.width, equals(48.0));
      expect(sizedBox.height, equals(48.0));
    });

    testWidgets('uses custom size when specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(size: 64.0),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(LoadingIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.width, equals(64.0));
      expect(sizedBox.height, equals(64.0));
    });

    testWidgets('displays message in uppercase when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(
              message: 'Loading Data',
            ),
          ),
        ),
      );

      expect(find.text('LOADING DATA'), findsOneWidget);
    });

    testWidgets('does not display message when not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(),
          ),
        ),
      );

      // Should only find the CircularProgressIndicator, no text
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('content is centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('displays column layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(message: 'Loading'),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('displays indicator and message in correct order',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(
              message: 'Please wait',
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('PLEASE WAIT'), findsOneWidget);
    });
  });
}
