import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/buttons/text_button.dart';

void main() {
  group('AppTextButton', () {
    testWidgets('displays text in uppercase', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextButton(text: 'Skip'),
          ),
        ),
      );

      expect(find.text('SKIP'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              text: 'Skip',
              onPressed: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppTextButton));
      expect(wasTapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              text: 'Skip',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppTextButton));
      expect(wasTapped, isFalse);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              text: 'Skip',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('SKIP'), findsNothing);
    });

    testWidgets('does not call onPressed when loading', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              text: 'Skip',
              onPressed: () => wasTapped = true,
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppTextButton));
      expect(wasTapped, isFalse);
    });

    testWidgets('displays icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              text: 'Learn More',
              icon: Icons.info,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('LEARN MORE'), findsOneWidget);
    });

    testWidgets('renders as TextButton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextButton(text: 'Skip'),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('icon and text are in a row when icon is provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextButton(
              text: 'Help',
              icon: Icons.help_outline,
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
      expect(find.text('HELP'), findsOneWidget);
    });
  });
}
