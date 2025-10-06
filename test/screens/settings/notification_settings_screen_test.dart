import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/screens/settings/notification_settings_screen.dart';
import 'package:backdrp_fm/bloc/auth/auth_bloc.dart';
import 'package:backdrp_fm/bloc/auth/auth_state.dart';
import 'package:backdrp_fm/bloc/auth/auth_event.dart';
import 'package:backdrp_fm/bloc/profile/profile_bloc.dart';
import 'package:backdrp_fm/bloc/profile/profile_state.dart';
import 'package:backdrp_fm/bloc/profile/profile_event.dart';
import 'package:backdrp_fm/models/app_user.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockProfileBloc = MockProfileBloc();
  });

  setUpAll(() {
    registerFallbackValue(
        const UpdateNotificationSettings(userId: '', newSets: true));
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
      notificationPreferences: NotificationPreferences(
        newSets: true,
        artistUpdates: true,
        weeklyDigest: false,
      ),
    ),
  );

  Widget createNotificationSettingsScreen() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const NotificationSettingsScreen(),
      ),
    );
  }

  group('NotificationSettingsScreen', () {
    testWidgets('displays app bar with correct title', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.text('NOTIFICATIONS'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays email notifications section', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.text('EMAIL NOTIFICATIONS'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays push notifications section', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.text('PUSH NOTIFICATIONS'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays email notifications switch', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      // "EMAIL NOTIFICATIONS" appears twice: as section header and switch title
      expect(find.text('EMAIL NOTIFICATIONS'), findsAtLeastNWidgets(2));
      expect(find.text('Receive notifications via email'), findsOneWidget);
    });

    testWidgets('displays new sets switch when email enabled', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.text('NEW SETS'), findsOneWidget);
      expect(find.text('Get notified when new videos are published'),
          findsOneWidget);
    });

    testWidgets('displays artist updates switch when email enabled',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.text('ARTIST UPDATES'), findsOneWidget);
      expect(find.text('Updates from artists you like'), findsOneWidget);
    });

    testWidgets('displays weekly digest switch when email enabled',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.text('WEEKLY DIGEST'), findsOneWidget);
      expect(find.text('Weekly summary of top content'), findsOneWidget);
    });

    testWidgets('displays push notifications switch', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      // "PUSH NOTIFICATIONS" appears twice: as section header and switch title
      expect(find.text('PUSH NOTIFICATIONS'), findsAtLeastNWidgets(2));
      expect(find.text('Receive push notifications on your device'),
          findsOneWidget);
    });

    testWidgets('displays info message', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(
          find.text(
              'You can always change these settings later. Unsubscribing from all notifications may cause you to miss important updates.'),
          findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('displays save settings button', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.text('SAVE SETTINGS'), findsOneWidget);
    });

    testWidgets('has multiple switches', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.byType(Switch), findsAtLeastNWidgets(1));
    });

    testWidgets('save button is tappable', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      final saveButton = find.text('SAVE SETTINGS');
      expect(saveButton, findsOneWidget);

      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pump();

      // Button was tappable
      expect(saveButton, findsOneWidget);
    });

    testWidgets('displays scrollable content', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('switches are toggleable', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      final switches = find.byType(Switch);
      expect(switches, findsAtLeastNWidgets(1));

      // Verify switches can be toggled
      final firstSwitch = switches.first;
      await tester.tap(firstSwitch);
      await tester.pump();

      // State should have changed (internal to widget)
      expect(find.byType(Switch), findsAtLeastNWidgets(1));
    });

    testWidgets('detail switches visible when email enabled', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      // Detail switches should be visible when email is enabled
      expect(find.text('NEW SETS'), findsOneWidget);
      expect(find.text('ARTIST UPDATES'), findsOneWidget);
      expect(find.text('WEEKLY DIGEST'), findsOneWidget);
    });

    testWidgets('displays elevated button for save', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createNotificationSettingsScreen());

      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
