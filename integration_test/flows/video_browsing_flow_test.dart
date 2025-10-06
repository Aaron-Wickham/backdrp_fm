import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backdrp_fm/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Video Browsing Flow Integration Tests', () {
    testWidgets('Browse videos on home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip authentication if needed
      // This assumes you're either logged in or can skip login

      // Verify home screen loads
      expect(find.text('HOME'), findsWidgets);

      // Wait for videos to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify video cards are displayed
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Navigate to video detail screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for videos to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap on first video card
      final videoCard = find.byType(Card).first;
      await tester.tap(videoCard);
      await tester.pumpAndSettle();

      // Verify video detail screen elements
      expect(find.byIcon(Icons.thumb_up_outlined), findsWidgets);
      expect(find.byIcon(Icons.share), findsWidgets);
    });

    testWidgets('Search for videos', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to search screen
      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      // Verify search screen
      expect(find.text('SEARCH'), findsWidgets);

      // Enter search query
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify results or empty state
      // This will depend on your test data
    });

    testWidgets('Filter videos by category', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for category chips or filters
      final chipFinder = find.byType(ChoiceChip);
      if (chipFinder.evaluate().isNotEmpty) {
        await tester.tap(chipFinder.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify filtered content loads
        expect(find.byType(Card), findsWidgets);
      }
    });

    testWidgets('Navigate to archive screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap archive navigation item
      final archiveIcon = find.byIcon(Icons.video_library);
      await tester.tap(archiveIcon);
      await tester.pumpAndSettle();

      // Verify archive screen
      expect(find.text('ARCHIVE'), findsWidgets);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('Browse artists screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap artists navigation item
      final artistsIcon = find.byIcon(Icons.people);
      await tester.tap(artistsIcon);
      await tester.pumpAndSettle();

      // Verify artists screen
      expect(find.text('ARTISTS'), findsWidgets);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify artist cards are displayed
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Navigate to artist detail screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to artists screen
      final artistsIcon = find.byIcon(Icons.people);
      await tester.tap(artistsIcon);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap on first artist card
      final artistCard = find.byType(Card).first;
      await tester.tap(artistCard);
      await tester.pumpAndSettle();

      // Verify artist detail screen elements
      expect(find.byIcon(Icons.location_on), findsWidgets);
      expect(find.text('VIDEOS'), findsWidgets);
    });

    testWidgets('Pull to refresh on home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Perform pull to refresh gesture
      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify content reloads
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Scroll through video list', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for initial content
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Scroll down
      await tester.drag(
        find.byType(ListView).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Verify still on home screen
      expect(find.text('HOME'), findsWidgets);
    });

    testWidgets('Navigate back from video detail', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for videos to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap on video card
      final videoCard = find.byType(Card).first;
      await tester.tap(videoCard);
      await tester.pumpAndSettle();

      // Tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify back on home screen
      expect(find.text('HOME'), findsWidgets);
    });
  });
}
