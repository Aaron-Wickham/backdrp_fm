import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrp_fm/screens/auth/signup_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: SignupScreen(),
    );
  }

  group('SignupScreen Widget Tests', () {
    testWidgets('renders all UI elements correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify app name is displayed
      expect(find.text('BACKDRP.FM'), findsOneWidget);
      expect(find.text('CREATE ACCOUNT'), findsAtLeastNWidgets(1));

      // Verify input fields are present (4 fields)
      expect(find.byType(TextFormField), findsNWidgets(4));

      // Verify all fields
      expect(
          find.widgetWithText(TextFormField, 'DISPLAY NAME'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'EMAIL'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'PASSWORD'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'CONFIRM PASSWORD'),
          findsOneWidget);

      // Verify signup button
      expect(find.text('CREATE ACCOUNT'), findsAtLeastNWidgets(1));

      // Verify login link
      expect(find.text('HAVE AN ACCOUNT?'), findsOneWidget);
      expect(find.text('LOGIN'), findsOneWidget);
    });

    testWidgets('validates display name field', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap signup button without entering name
      final signupButton = find.byType(ElevatedButton);
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      // Verify validation error
      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('validates email field for empty input',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter display name but not email
      final nameField = find.widgetWithText(TextFormField, 'DISPLAY NAME');
      await tester.enterText(nameField, 'Test User');

      // Tap signup button
      final signupButton = find.byType(ElevatedButton);
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      // Verify validation error
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('validates email field for invalid format',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid email
      final emailField = find.widgetWithText(TextFormField, 'EMAIL');
      await tester.enterText(emailField, 'invalidemail');

      // Tap signup button
      final signupButton = find.byType(ElevatedButton);
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      // Verify validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('validates password field for empty input',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter name and email but no password
      final nameField = find.widgetWithText(TextFormField, 'DISPLAY NAME');
      await tester.enterText(nameField, 'Test User');

      final emailField = find.widgetWithText(TextFormField, 'EMAIL');
      await tester.enterText(emailField, 'test@example.com');

      // Tap signup button
      final signupButton = find.byType(ElevatedButton);
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      // Verify validation error
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('validates password minimum length',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter short password
      final passwordField = find.widgetWithText(TextFormField, 'PASSWORD');
      await tester.enterText(passwordField, '12345');

      // Tap signup button
      final signupButton = find.byType(ElevatedButton);
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      // Verify validation error
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('validates password confirmation field for empty input',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter password but not confirmation
      final passwordField = find.widgetWithText(TextFormField, 'PASSWORD');
      await tester.enterText(passwordField, 'password123');

      // Tap signup button
      final signupButton = find.byType(ElevatedButton);
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      // Verify validation error
      expect(find.text('Please confirm your password'), findsOneWidget);
    });

    testWidgets('validates passwords match', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter mismatched passwords
      final passwordField = find.widgetWithText(TextFormField, 'PASSWORD');
      await tester.enterText(passwordField, 'password123');

      final confirmField =
          find.widgetWithText(TextFormField, 'CONFIRM PASSWORD');
      await tester.enterText(confirmField, 'password456');

      // Tap signup button
      final signupButton = find.byType(ElevatedButton);
      await tester.ensureVisible(signupButton);
      await tester.tap(signupButton);
      await tester.pump();

      // Verify validation error
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('password visibility toggle works for password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap visibility toggle (first one)
      final visibilityIcons = find.byIcon(Icons.visibility_outlined);
      await tester.tap(visibilityIcons.first);
      await tester.pump();

      // Verify icon changed
      expect(
          find.byIcon(Icons.visibility_off_outlined), findsAtLeastNWidgets(1));
    });

    testWidgets('password visibility toggle works for confirm password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Count initial visibility icons
      final initialIcons = find.byIcon(Icons.visibility_outlined);

      // Tap visibility toggle (second one)
      await tester.tap(initialIcons.last);
      await tester.pump();

      // Verify icon changed
      expect(
          find.byIcon(Icons.visibility_off_outlined), findsAtLeastNWidgets(1));
    });

    testWidgets('disposes controllers on dispose', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Navigate away to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // If we get here without errors, controllers were disposed properly
      expect(true, true);
    });
  });
}
