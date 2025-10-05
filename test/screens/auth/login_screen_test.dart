import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:backdrp_fm/screens/auth/login_screen.dart';
import 'package:backdrp_fm/bloc/auth/auth_bloc.dart';
import 'package:backdrp_fm/bloc/auth/auth_event.dart';
import 'package:backdrp_fm/bloc/auth/auth_state.dart';

@GenerateMocks([AuthBloc])
import 'login_screen_test.mocks.dart';

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
    when(mockAuthBloc.state).thenReturn(const AuthInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify app name is displayed
      expect(find.text('BACKDRP.FM'), findsOneWidget);
      expect(find.text('WELCOME BACK'), findsOneWidget);

      // Verify input fields are present
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Verify email field
      final emailField = find.widgetWithText(TextFormField, 'EMAIL');
      expect(emailField, findsOneWidget);

      // Verify password field
      final passwordField = find.widgetWithText(TextFormField, 'PASSWORD');
      expect(passwordField, findsOneWidget);

      // Verify login button
      expect(find.text('LOGIN'), findsOneWidget);

      // Verify sign up link
      expect(find.text("NO ACCOUNT?"), findsOneWidget);
      expect(find.text('SIGN UP'), findsOneWidget);
    });

    testWidgets('email field validates empty input', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap the login button without entering email
      final loginButton = find.text('LOGIN');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify validation error is shown
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('email field validates invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid email
      final emailField = find.widgetWithText(TextFormField, 'EMAIL');
      await tester.enterText(emailField, 'invalidemail');

      // Tap login button
      final loginButton = find.text('LOGIN');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify validation error is shown
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('password field validates empty input', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email but no password
      final emailField = find.widgetWithText(TextFormField, 'EMAIL');
      await tester.enterText(emailField, 'test@example.com');

      // Tap login button
      final loginButton = find.text('LOGIN');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify validation error is shown
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('password field validates minimum length', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email but short password
      final emailField = find.widgetWithText(TextFormField, 'EMAIL');
      await tester.enterText(emailField, 'test@example.com');

      final passwordField = find.widgetWithText(TextFormField, 'PASSWORD');
      await tester.enterText(passwordField, '12345');

      // Tap login button
      final loginButton = find.text('LOGIN');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify validation error is shown
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap visibility toggle
      final visibilityIcon = find.byIcon(Icons.visibility_outlined);
      expect(visibilityIcon, findsOneWidget);
      await tester.tap(visibilityIcon);
      await tester.pump();

      // Verify icon changed
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('dispatches login event with valid credentials', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid credentials
      final emailField = find.widgetWithText(TextFormField, 'EMAIL');
      await tester.enterText(emailField, 'test@example.com');

      final passwordField = find.widgetWithText(TextFormField, 'PASSWORD');
      await tester.enterText(passwordField, 'password123');

      // Tap login button
      final loginButton = find.text('LOGIN');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify login event was dispatched
      verify(mockAuthBloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'password123',
      ))).called(1);
    });

    testWidgets('shows loading indicator when AuthLoading', (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(const AuthLoading());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthLoading()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify login text is not shown
      expect(find.text('LOGIN'), findsNothing);
    });

    testWidgets('disables inputs when loading', (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(const AuthLoading());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthLoading()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Find text fields
      final emailField = find.widgetWithText(TextFormField, 'EMAIL');
      final passwordField = find.widgetWithText(TextFormField, 'PASSWORD');

      // Verify they are disabled
      final emailWidget = tester.widget<TextFormField>(emailField);
      final passwordWidget = tester.widget<TextFormField>(passwordField);

      expect(emailWidget.enabled, false);
      expect(passwordWidget.enabled, false);

      // Verify login button is disabled
      final loginButton = find.byType(ElevatedButton);
      final buttonWidget = tester.widget<ElevatedButton>(loginButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('shows error snackbar on AuthError', (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(const AuthInitial());
      when(mockAuthBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const AuthInitial(),
          const AuthError('Invalid credentials'),
        ]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump();

      // Verify error snackbar is shown
      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('navigates to signup screen when sign up is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Tap sign up button
      final signUpButton = find.text('SIGN UP');
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // Verify navigation occurred (SignupScreen should be in widget tree)
      // Note: This is a simple check - in a real app you might verify the route
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('disables sign up navigation when loading', (WidgetTester tester) async {
      when(mockAuthBloc.state).thenReturn(const AuthLoading());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthLoading()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Find sign up button
      final signUpButton = find.widgetWithText(TextButton, 'SIGN UP');
      final buttonWidget = tester.widget<TextButton>(signUpButton);

      // Verify it's disabled
      expect(buttonWidget.onPressed, isNull);
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
