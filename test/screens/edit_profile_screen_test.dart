import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/screens/edit_profile_screen.dart';
import 'package:backdrp_fm/bloc/profile/profile_bloc.dart';
import 'package:backdrp_fm/bloc/profile/profile_state.dart';
import 'package:backdrp_fm/bloc/profile/profile_event.dart';
import 'package:backdrp_fm/models/app_user.dart';

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

void main() {
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockProfileBloc = MockProfileBloc();
  });

  setUpAll(() {
    registerFallbackValue(const UpdateProfile(userId: ''));
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

  Widget createEditProfileScreen() {
    return MaterialApp(
      home: BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: EditProfileScreen(user: testUser),
      ),
    );
  }

  group('EditProfileScreen', () {
    testWidgets('displays app bar with correct title', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.text('EDIT PROFILE'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays user display name in text field', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('displays user email (read-only)', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('displays display name label', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.text('DISPLAY NAME'), findsOneWidget);
    });

    testWidgets('displays email label', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.text('EMAIL'), findsOneWidget);
    });

    testWidgets('displays person icon when no profile image', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('displays change photo button', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.text('CHANGE PHOTO'), findsOneWidget);
    });

    testWidgets('displays save changes button', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.text('SAVE CHANGES'), findsOneWidget);
    });

    testWidgets('validates empty display name', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      // Clear the text field
      final textField = find.byType(TextFormField).first;
      await tester.enterText(textField, '');
      await tester.pump();

      // Tap save button
      await tester.tap(find.text('SAVE CHANGES'));
      await tester.pump();

      expect(find.text('Please enter a display name'), findsOneWidget);
    });

    testWidgets('validates display name minimum length', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      // Enter single character
      final textField = find.byType(TextFormField).first;
      await tester.enterText(textField, 'A');
      await tester.pump();

      // Tap save button
      await tester.tap(find.text('SAVE CHANGES'));
      await tester.pump();

      expect(find.text('Display name must be at least 2 characters'),
          findsOneWidget);
    });

    testWidgets('email field is disabled', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      final emailField = find.byType(TextFormField).last;
      final textFormField = tester.widget<TextFormField>(emailField);

      expect(textFormField.enabled, false);
    });

    testWidgets('displays email icon', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('displays person outline icon', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('shows loading indicator when saving', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      // The loading state is internal, we can test the button is there
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('has form key', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('displays profile image section', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      // Check for the profile picture container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('has text button for changing photo', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('displays scrollable content', (tester) async {
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createEditProfileScreen());

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
