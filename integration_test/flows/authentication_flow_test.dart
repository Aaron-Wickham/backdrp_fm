import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backdrp_fm/main.dart' as app;

// NOTE: Before running integration tests, start Firebase Emulators:
// firebase emulators:start

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    testWidgets('Complete signup flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to signup screen
      final signupButton = find.text('SIGN UP');
      expect(signupButton, findsOneWidget);
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      // Fill in signup form
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Test User',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'testuser@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'password123',
      );
      await tester.enterText(
        find.byType(TextFormField).at(3),
        'password123',
      );

      // Scroll to and tap signup button
      final submitButton = find.byType(ElevatedButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify navigation to home screen or success state
      // Note: This will depend on your Firebase configuration
      // In a real test environment, you'd use Firebase Emulator
    });

    testWidgets('Complete login flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should be on login screen by default
      expect(find.text('LOGIN'), findsWidgets);

      // Fill in login form
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'testuser@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'password123',
      );

      // Tap login button
      final loginButton = find.byType(ElevatedButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify navigation to home screen
      // Note: This will depend on your Firebase configuration
    });

    testWidgets('Form validation on signup', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to signup screen
      await tester.tap(find.text('SIGN UP'));
      await tester.pumpAndSettle();

      // Try to submit without filling form
      final submitButton = find.byType(ElevatedButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump();

      // Verify validation errors appear
      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter a password'), findsOneWidget);
    });

    testWidgets('Form validation on login', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try to submit login without filling form
      final loginButton = find.byType(ElevatedButton);
      await tester.tap(loginButton);
      await tester.pump();

      // Verify validation errors appear
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Toggle password visibility', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find password field visibility toggle
      final visibilityIcon = find.byIcon(Icons.visibility);
      expect(visibilityIcon, findsAtLeastNWidgets(1));

      // Tap to toggle visibility
      await tester.tap(visibilityIcon.first);
      await tester.pump();

      // Verify icon changed to visibility_off
      expect(find.byIcon(Icons.visibility_off), findsAtLeastNWidgets(1));
    });

    testWidgets('Navigate between login and signup', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Start on login screen
      expect(find.text('LOGIN'), findsWidgets);

      // Navigate to signup
      await tester.tap(find.text('SIGN UP'));
      await tester.pumpAndSettle();

      expect(find.text('CREATE ACCOUNT'), findsOneWidget);

      // Navigate back to login
      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle();

      expect(find.text('LOGIN'), findsWidgets);
    });
  });
}
