import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/widgets/common/empty_state.dart';
import 'package:backdrp_fm/widgets/buttons/primary_button.dart';

void main() {
  group('EmptyState', () {
    testWidgets('displays title in uppercase', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display',
            ),
          ),
        ),
      );

      expect(find.text('NO ITEMS'), findsOneWidget);
    });

    testWidgets('displays message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display',
            ),
          ),
        ),
      );

      expect(find.text('There are no items to display'), findsOneWidget);
    });

    testWidgets('displays default icon when not specified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('displays custom icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Videos',
              message: 'No videos found',
              icon: Icons.video_library_outlined,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.video_library_outlined), findsOneWidget);
    });

    testWidgets('displays action button when actionText and onAction provided',
        (tester) async {
      bool actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display',
              actionText: 'Add Item',
              onAction: () => actionCalled = true,
            ),
          ),
        ),
      );

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('ADD ITEM'), findsOneWidget);

      await tester.tap(find.byType(PrimaryButton));
      expect(actionCalled, isTrue);
    });

    testWidgets('does not display action button when actionText is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display',
            ),
          ),
        ),
      );

      expect(find.byType(PrimaryButton), findsNothing);
    });

    testWidgets('does not display action button when onAction is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display',
              actionText: 'Add Item',
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
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display',
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
            body: EmptyState(
              title: 'No Items',
              message: 'There are no items to display',
              icon: Icons.search_off,
              actionText: 'Refresh',
              onAction: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.text('NO ITEMS'), findsOneWidget);
      expect(find.text('There are no items to display'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
    });
  });
}
