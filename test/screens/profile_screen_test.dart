import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/screens/profile_screen.dart';
import 'package:backdrp_fm/bloc/auth/auth_bloc.dart';
import 'package:backdrp_fm/bloc/auth/auth_state.dart';
import 'package:backdrp_fm/bloc/auth/auth_event.dart';
import 'package:backdrp_fm/bloc/profile/profile_bloc.dart';
import 'package:backdrp_fm/bloc/profile/profile_state.dart';
import 'package:backdrp_fm/bloc/profile/profile_event.dart';
import 'package:backdrp_fm/models/app_user.dart';
import 'package:backdrp_fm/models/video.dart';

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
    registerFallbackValue(const LoadProfile(''));
    registerFallbackValue(const LoadSavedVideos(''));
    registerFallbackValue(const AuthLoggedOut());
  });

  final testUser = AppUser(
    uid: 'user1',
    email: 'test@example.com',
    displayName: 'Test User',
    role: UserRole.user,
    likedVideos: const ['video1', 'video2'],
    savedVideos: const ['video3'],
    emailSubscribed: true,
    pushSubscribed: true,
    preferences: UserPreferences(
      favoriteGenres: const ['Electronic'],
    ),
  );

  final testVideo = Video(
    id: 'video3',
    youtubeUrl: 'https://youtube.com/watch?v=test123',
    youtubeId: 'test123',
    thumbnailUrl: 'https://img.youtube.com/vi/test123/maxresdefault.jpg',
    title: 'Test Video',
    artist: 'Test Artist',
    artistId: 'artist1',
    description: 'Test description',
    genres: ['Electronic'],
    location: VideoLocation(
      venue: 'Test Venue',
      city: 'Los Angeles',
      country: 'USA',
    ),
    duration: 180,
    status: 'published',
    likes: 10,
    views: 100,
    featured: true,
    sortOrder: 1,
    tags: ['live'],
  );

  Widget createProfileScreen() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen', () {
    testWidgets('displays loading when not authenticated', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('LOADING PROFILE'), findsOneWidget);
    });

    testWidgets('displays user display name', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.text('TEST USER'), findsOneWidget);
    });

    testWidgets('displays user email', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('displays liked videos count', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('LIKED'), findsOneWidget);
    });

    testWidgets('displays saved videos count', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('SAVED'), findsOneWidget);
    });

    testWidgets('displays default name when displayName is empty',
        (tester) async {
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
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.text('USER'), findsOneWidget);
    });

    testWidgets('displays person icon when no profile image', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('dispatches LoadProfile on init', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      verify(() => mockProfileBloc.add(const LoadProfile('user1'))).called(1);
    });

    testWidgets('dispatches LoadSavedVideos on init', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      verify(() => mockProfileBloc.add(const LoadSavedVideos('user1')))
          .called(1);
    });

    testWidgets('displays saved videos section header', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.text('SAVED VIDEOS'), findsOneWidget);
    });

    testWidgets('displays loading indicator when profile is loading',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileLoading());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('LOADING SAVED VIDEOS'), findsOneWidget);
    });

    testWidgets('displays empty state when no saved videos', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(ProfileLoaded(
        user: testUser,
        savedVideos: const [],
      ));

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.text('NO SAVED VIDEOS'), findsOneWidget);
      expect(find.text('Videos you save will appear here'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsAtLeastNWidgets(1));
    });

    testWidgets('displays saved videos list when loaded', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(ProfileLoaded(
        user: testUser,
        savedVideos: [testVideo],
      ));

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('TEST VIDEO'), findsOneWidget);
    });

    testWidgets('displays settings floating action button', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('SETTINGS'), findsOneWidget);
    });

    testWidgets('displays SliverAppBar', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('displays CustomScrollView', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('displays stats with icons', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockProfileBloc.state).thenReturn(const ProfileInitial());

      await tester.pumpWidget(createProfileScreen());
      await tester.pump();

      expect(find.byIcon(Icons.favorite_border), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.bookmark_border), findsAtLeastNWidgets(1));
    });

    testWidgets('rebuilds when ProfileBloc state changes', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));

      whenListen(
        mockProfileBloc,
        Stream.fromIterable([
          const ProfileLoading(),
          ProfileLoaded(user: testUser, savedVideos: [testVideo]),
        ]),
        initialState: const ProfileInitial(),
      );

      await tester.pumpWidget(createProfileScreen());

      // Wait for state change
      await tester.pumpAndSettle();

      // Shows video after loading
      expect(find.text('TEST VIDEO'), findsOneWidget);
    });
  });
}
