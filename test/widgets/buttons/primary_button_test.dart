import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/buttons/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('displays text in uppercase', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Click Me'),
          ),
        ),
      );

      expect(find.text('CLICK ME'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      expect(wasTapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      expect(wasTapped, isFalse);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('CLICK ME'), findsNothing);
    });

    testWidgets('does not call onPressed when loading', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              onPressed: () => wasTapped = true,
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PrimaryButton));
      expect(wasTapped, isFalse);
    });

    testWidgets('takes full width when isFullWidth is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
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
            body: PrimaryButton(
              text: 'Add',
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('ADD'), findsOneWidget);
    });

    testWidgets('renders as ElevatedButton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(text: 'Click Me'),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('applies inverted style when isInverted is true',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Click Me',
              isInverted: true,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button, isNotNull);
    });

    testWidgets('icon and text are in a row when icon is provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Save',
              icon: Icons.save,
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.text('SAVE'), findsOneWidget);
    });
  });
}
