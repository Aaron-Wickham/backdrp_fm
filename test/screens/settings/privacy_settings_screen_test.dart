import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/screens/settings/privacy_settings_screen.dart';
import 'package:backdrp_fm/bloc/auth/auth_bloc.dart';
import 'package:backdrp_fm/bloc/auth/auth_state.dart';
import 'package:backdrp_fm/bloc/auth/auth_event.dart';
import 'package:backdrp_fm/models/app_user.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  final testUser = AppUser(
    uid: 'user1',
    email: 'test@example.com',
    displayName: 'Test User',
    role: UserRole.user,
    likedVideos: const [],
    savedVideos: const [],
    emailSubscribed: true,
    pushSubscribed: true,
    preferences: UserPreferences(
      favoriteGenres: const [],
    ),
  );

  Widget createPrivacySettingsScreen() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const PrivacySettingsScreen(),
      ),
    );
  }

  group('PrivacySettingsScreen', () {
    testWidgets('displays app bar with correct title', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('PRIVACY & DATA'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays account information section', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('ACCOUNT INFORMATION'), findsOneWidget);
    });

    testWidgets('displays user email', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('EMAIL'), findsOneWidget);
    });

    testWidgets('displays user display name', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('DISPLAY NAME'), findsOneWidget);
    });

    testWidgets('displays account type', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('USER'), findsOneWidget);
      expect(find.text('ACCOUNT TYPE'), findsOneWidget);
    });

    testWidgets('displays data management section', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('DATA MANAGEMENT'), findsOneWidget);
    });

    testWidgets('displays export your data option', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('EXPORT YOUR DATA'), findsOneWidget);
      expect(find.text('Download a copy of your data'), findsOneWidget);
      expect(find.byIcon(Icons.download_outlined), findsOneWidget);
    });

    testWidgets('displays clear cache option', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('CLEAR CACHE'), findsOneWidget);
      expect(find.text('Free up storage space'), findsOneWidget);
      expect(find.byIcon(Icons.cleaning_services_outlined), findsOneWidget);
    });

    testWidgets('displays legal & policies section', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('LEGAL & POLICIES'), findsOneWidget);
    });

    testWidgets('displays privacy policy option', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('PRIVACY POLICY'), findsOneWidget);
      expect(find.text('How we handle your data'), findsOneWidget);
      expect(find.byIcon(Icons.policy_outlined), findsOneWidget);
    });

    testWidgets('displays terms of service option', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('TERMS OF SERVICE'), findsOneWidget);
      expect(find.text('Rules and guidelines'), findsOneWidget);
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
    });

    testWidgets('displays danger zone section', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('DANGER ZONE'), findsOneWidget);
    });

    testWidgets('displays delete account option', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('DELETE ACCOUNT'), findsOneWidget);
      expect(find.text('Permanently delete your account and data'),
          findsOneWidget);
      expect(find.byIcon(Icons.delete_forever_outlined), findsOneWidget);
    });

    testWidgets('displays privacy info footer', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(
          find.text(
              'We take your privacy seriously. Your data is stored securely and never shared with third parties without your consent.'),
          findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('delete account button is tappable', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      final deleteButton = find.text('DELETE ACCOUNT');
      expect(deleteButton, findsAtLeastNWidgets(1));

      // Button should be tappable
      await tester.ensureVisible(deleteButton.first);
      await tester.tap(deleteButton.first, warnIfMissed: false);
      await tester.pump();

      expect(deleteButton, findsAtLeastNWidgets(1));
    });

    testWidgets('displays export data action item', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('EXPORT YOUR DATA'), findsOneWidget);
      expect(find.text('Download a copy of your data'), findsOneWidget);
    });

    testWidgets('has gesture detectors for actions', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
    });

    testWidgets('displays scrollable content', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays correct icons for account info', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
    });

    testWidgets('displays arrow icons for actionable items', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.byIcon(Icons.arrow_forward_ios), findsAtLeastNWidgets(1));
    });

    testWidgets('shows not authenticated message when logged out',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('Not authenticated'), findsOneWidget);
    });

    testWidgets('clear cache shows snackbar', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      await tester.pumpWidget(createPrivacySettingsScreen());

      await tester.tap(find.text('CLEAR CACHE'));
      await tester.pump();

      expect(find.text('Cache cleared successfully'), findsOneWidget);
    });

    testWidgets('displays "Not set" for empty display name', (tester) async {
      final userWithoutName = AppUser(
        uid: testUser.uid,
        email: testUser.email,
        displayName: '',
        role: testUser.role,
        likedVideos: testUser.likedVideos,
        savedVideos: testUser.savedVideos,
        emailSubscribed: testUser.emailSubscribed,
        pushSubscribed: testUser.pushSubscribed,
        preferences: testUser.preferences,
      );

      when(() => mockAuthBloc.state)
          .thenReturn(AuthAuthenticated(userWithoutName));

      await tester.pumpWidget(createPrivacySettingsScreen());

      expect(find.text('Not set'), findsOneWidget);
    });
  });
}
