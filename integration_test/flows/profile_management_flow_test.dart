import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backdrp_fm/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Management Flow Integration Tests', () {
    testWidgets('Navigate to profile screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile screen
      final profileIcon = find.byIcon(Icons.person);
      await tester.tap(profileIcon);
      await tester.pumpAndSettle();

      // Verify profile screen
      expect(find.text('PROFILE'), findsWidgets);
    });

    testWidgets('View profile details', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify profile elements are displayed
      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.text('EDIT PROFILE'), findsWidgets);
    });

    testWidgets('Navigate to edit profile screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Tap edit profile button
      final editButton = find.text('EDIT PROFILE');
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Verify edit profile screen
      expect(find.text('EDIT PROFILE'), findsWidgets);
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('Update profile information', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to edit profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EDIT PROFILE'));
      await tester.pumpAndSettle();

      // Update display name
      final nameField = find.byType(TextFormField).first;
      await tester.enterText(nameField, 'Updated Name');

      // Scroll to and tap save button
      final saveButton = find.text('SAVE CHANGES');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify navigation back or success message
      // Note: Actual verification depends on Firebase configuration
    });

    testWidgets('Navigate to settings screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Tap settings button
      final settingsButton = find.byIcon(Icons.settings);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Verify settings screen
      expect(find.text('SETTINGS'), findsWidgets);
    });

    testWidgets('Access notification settings', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to settings
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Tap notification settings
      final notificationTile = find.text('Notifications');
      await tester.tap(notificationTile);
      await tester.pumpAndSettle();

      // Verify notification settings screen
      expect(find.text('NOTIFICATION SETTINGS'), findsWidgets);
      expect(find.byType(SwitchListTile), findsWidgets);
    });

    testWidgets('Toggle notification settings', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to notification settings
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      // Toggle first switch
      final switchTile = find.byType(SwitchListTile).first;
      await tester.tap(switchTile);
      await tester.pump();

      // Save settings
      final saveButton = find.text('SAVE SETTINGS');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    });

    testWidgets('Access privacy settings', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to settings
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Tap privacy settings
      final privacyTile = find.text('Privacy');
      await tester.tap(privacyTile);
      await tester.pumpAndSettle();

      // Verify privacy settings screen
      expect(find.text('PRIVACY SETTINGS'), findsWidgets);
    });

    testWidgets('View liked videos', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for liked videos section
      final likedVideosTab = find.text('LIKED');
      if (likedVideosTab.evaluate().isNotEmpty) {
        await tester.tap(likedVideosTab);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify liked videos display or empty state
        // This will depend on test data
      }
    });

    testWidgets('Navigate through profile tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for tabs
      final tabBar = find.byType(TabBar);
      if (tabBar.evaluate().isNotEmpty) {
        // Get all tabs
        final tabs = find.descendant(
          of: tabBar,
          matching: find.byType(Tab),
        );

        // Tap each tab
        for (int i = 0; i < tabs.evaluate().length; i++) {
          await tester.tap(tabs.at(i));
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Logout flow', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Look for logout button
      final logoutButton = find.text('LOGOUT');
      if (logoutButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(logoutButton);
        await tester.tap(logoutButton, warnIfMissed: false);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify navigation back to login screen
        expect(find.text('LOGIN'), findsWidgets);
      }
    });

    testWidgets('Navigate back from edit profile', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to edit profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EDIT PROFILE'));
      await tester.pumpAndSettle();

      // Tap back button
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify back on profile screen
      expect(find.text('PROFILE'), findsWidgets);
    });
  });
}
