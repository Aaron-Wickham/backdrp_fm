import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/buttons/secondary_button.dart';

void main() {
  group('SecondaryButton', () {
    testWidgets('displays text in uppercase', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Cancel'),
          ),
        ),
      );

      expect(find.text('CANCEL'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Cancel',
              onPressed: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SecondaryButton));
      expect(wasTapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Cancel',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SecondaryButton));
      expect(wasTapped, isFalse);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Cancel',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('CANCEL'), findsNothing);
    });

    testWidgets('does not call onPressed when loading', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Cancel',
              onPressed: () => wasTapped = true,
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SecondaryButton));
      expect(wasTapped, isFalse);
    });

    testWidgets('takes full width when isFullWidth is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Cancel',
              isFullWidth: true,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, equals(double.infinity));
    });

    testWidgets('displays icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Back',
              icon: Icons.arrow_back,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('BACK'), findsOneWidget);
    });

    testWidgets('renders as OutlinedButton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(text: 'Cancel'),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('icon and text are in a row when icon is provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SecondaryButton(
              text: 'Delete',
              icon: Icons.delete,
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
      expect(find.text('DELETE'), findsOneWidget);
    });
  });
}
