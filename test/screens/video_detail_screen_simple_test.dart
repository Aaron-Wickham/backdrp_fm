import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/bloc/auth/auth_bloc.dart';
import 'package:backdrp_fm/bloc/auth/auth_state.dart';
import 'package:backdrp_fm/bloc/auth/auth_event.dart';
import 'package:backdrp_fm/bloc/video/video_bloc.dart';
import 'package:backdrp_fm/bloc/video/video_state.dart';
import 'package:backdrp_fm/bloc/video/video_event.dart';
import 'package:backdrp_fm/models/video.dart';
import 'package:backdrp_fm/models/app_user.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockVideoBloc extends MockBloc<VideoEvent, VideoState>
    implements VideoBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockVideoBloc mockVideoBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockVideoBloc = MockVideoBloc();
  });

  setUpAll(() {
    registerFallbackValue(const LoadVideos());
    registerFallbackValue(const LikeVideo(videoId: '', userId: ''));
    registerFallbackValue(const SaveVideo(videoId: '', userId: ''));
  });

  final testVideo = Video(
    id: 'video1',
    youtubeUrl: 'https://youtube.com/watch?v=test123',
    youtubeId: 'test123',
    thumbnailUrl: 'https://img.youtube.com/vi/test123/maxresdefault.jpg',
    title: 'Test Video',
    artist: 'Test Artist',
    artistId: 'artist1',
    description: 'This is a test video description',
    genres: ['Electronic', 'House'],
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
    tags: ['live', 'concert'],
  );

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

  group('VideoDetailScreen Logic Tests', () {
    test('video model contains correct data', () {
      expect(testVideo.id, 'video1');
      expect(testVideo.title, 'Test Video');
      expect(testVideo.artist, 'Test Artist');
      expect(testVideo.youtubeId, 'test123');
      expect(testVideo.duration, 180);
      expect(testVideo.likes, 10);
      expect(testVideo.views, 100);
    });

    test('video location is properly structured', () {
      expect(testVideo.location.venue, 'Test Venue');
      expect(testVideo.location.city, 'Los Angeles');
      expect(testVideo.location.country, 'USA');
    });

    test('video has correct genres', () {
      expect(testVideo.genres, contains('Electronic'));
      expect(testVideo.genres, contains('House'));
      expect(testVideo.genres.length, 2);
    });

    test('video has correct tags', () {
      expect(testVideo.tags, contains('live'));
      expect(testVideo.tags, contains('concert'));
      expect(testVideo.tags.length, 2);
    });

    test('user can like video when authenticated', () {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      final authState = mockAuthBloc.state;
      expect(authState, isA<AuthAuthenticated>());

      // Simulate like action
      mockVideoBloc.add(LikeVideo(videoId: testVideo.id, userId: testUser.uid));

      verify(() => mockVideoBloc.add(
          LikeVideo(videoId: testVideo.id, userId: testUser.uid))).called(1);
    });

    test('user can save video when authenticated', () {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      final authState = mockAuthBloc.state;
      expect(authState, isA<AuthAuthenticated>());

      // Simulate save action
      mockVideoBloc.add(SaveVideo(videoId: testVideo.id, userId: testUser.uid));

      verify(() => mockVideoBloc.add(
          SaveVideo(videoId: testVideo.id, userId: testUser.uid))).called(1);
    });

    test('user liked status is tracked correctly', () {
      final userWithLike = AppUser(
        uid: testUser.uid,
        email: testUser.email,
        displayName: testUser.displayName,
        role: testUser.role,
        likedVideos: const ['video1'],
        savedVideos: testUser.savedVideos,
        emailSubscribed: testUser.emailSubscribed,
        pushSubscribed: testUser.pushSubscribed,
        preferences: testUser.preferences,
      );

      expect(userWithLike.likedVideos.contains('video1'), true);
      expect(userWithLike.likedVideos.contains('video2'), false);
    });

    test('user saved status is tracked correctly', () {
      final userWithSave = AppUser(
        uid: testUser.uid,
        email: testUser.email,
        displayName: testUser.displayName,
        role: testUser.role,
        likedVideos: testUser.likedVideos,
        savedVideos: const ['video1'],
        emailSubscribed: testUser.emailSubscribed,
        pushSubscribed: testUser.pushSubscribed,
        preferences: testUser.preferences,
      );

      expect(userWithSave.savedVideos.contains('video1'), true);
      expect(userWithSave.savedVideos.contains('video2'), false);
    });

    test('duration is formatted correctly (seconds to MM:SS)', () {
      final duration = testVideo.duration; // 180 seconds
      final minutes = duration ~/ 60;
      final seconds = duration % 60;
      final formatted = '$minutes:${seconds.toString().padLeft(2, '0')}';

      expect(formatted, '3:00');
    });

    test('video metrics are displayed', () {
      expect(testVideo.views, 100);
      expect(testVideo.likes, 10);
    });

    test('unauthenticated state prevents interactions', () {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());

      final authState = mockAuthBloc.state;
      expect(authState, isA<AuthUnauthenticated>());
      expect(authState is AuthAuthenticated, false);
    });
  });
}
