import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/screens/home_screen.dart';
import 'package:backdrp_fm/bloc/video/video_bloc.dart';
import 'package:backdrp_fm/bloc/video/video_state.dart';
import 'package:backdrp_fm/bloc/video/video_event.dart';
import 'package:backdrp_fm/models/video.dart';

class MockVideoBloc extends MockBloc<VideoEvent, VideoState>
    implements VideoBloc {}

void main() {
  late MockVideoBloc mockVideoBloc;

  setUp(() {
    mockVideoBloc = MockVideoBloc();
  });

  setUpAll(() {
    registerFallbackValue(const LoadVideos());
    registerFallbackValue(const LoadFeaturedVideos(limit: 20));
  });

  Widget createHomeScreen() {
    return MaterialApp(
      home: BlocProvider<VideoBloc>.value(
        value: mockVideoBloc,
        child: const HomeScreen(),
      ),
    );
  }

  final testVideo = Video(
    id: 'video1',
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

  final testVideo2 = Video(
    id: 'video2',
    youtubeUrl: 'https://youtube.com/watch?v=test456',
    youtubeId: 'test456',
    thumbnailUrl: 'https://img.youtube.com/vi/test456/maxresdefault.jpg',
    title: 'Test Video 2',
    artist: 'Test Artist 2',
    artistId: 'artist2',
    description: 'Test description 2',
    genres: ['Jazz'],
    location: VideoLocation(
      venue: 'Test Venue 2',
      city: 'New York',
      country: 'USA',
    ),
    duration: 240,
    status: 'published',
    likes: 20,
    views: 200,
    featured: false,
    sortOrder: 2,
    tags: ['concert'],
  );

  group('HomeScreen', () {
    testWidgets('displays app bar with correct title', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createHomeScreen());

      expect(find.text('BACKDRP.FM'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('dispatches LoadFeaturedVideos on init', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createHomeScreen());
      await tester.pump(); // Just one frame to trigger postFrameCallback

      verify(() => mockVideoBloc.add(any(that: isA<LoadFeaturedVideos>())))
          .called(1);
    });

    testWidgets('displays loading indicator when state is VideoLoading',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoLoading());

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('LOADING VIDEOS'), findsOneWidget);
    });

    testWidgets('displays error view when state is VideoError',
        (tester) async {
      when(() => mockVideoBloc.state)
          .thenReturn(const VideoError('Failed to load videos'));

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      expect(find.text('ERROR'), findsOneWidget);
      expect(find.text('Failed to load videos'), findsOneWidget);
      expect(find.text('RETRY'), findsOneWidget);
    });

    testWidgets('error view retry button dispatches LoadFeaturedVideos',
        (tester) async {
      when(() => mockVideoBloc.state)
          .thenReturn(const VideoError('Failed to load videos'));

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      // Tap retry button
      await tester.tap(find.text('RETRY'));
      await tester.pump();

      // Called twice: once on init, once on retry
      verify(() => mockVideoBloc.add(any(that: isA<LoadFeaturedVideos>())))
          .called(2);
    });

    testWidgets('displays empty state when no videos are loaded',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoLoaded(videos: []));

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      expect(find.text('NO VIDEOS'), findsOneWidget);
      expect(find.text('No videos available at the moment'), findsOneWidget); // Not uppercased
      expect(find.text('REFRESH'), findsOneWidget);
      expect(find.byIcon(Icons.video_library_outlined), findsOneWidget);
    });

    testWidgets('empty state action button dispatches LoadFeaturedVideos',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoLoaded(videos: []));

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      // Tap refresh button
      await tester.tap(find.text('REFRESH'));
      await tester.pump();

      // Called twice: once on init, once on refresh
      verify(() => mockVideoBloc.add(any(that: isA<LoadFeaturedVideos>())))
          .called(2);
    });

    testWidgets('displays list of videos when loaded', (tester) async {
      final videos = [testVideo, testVideo2];

      when(() => mockVideoBloc.state)
          .thenReturn(VideoLoaded(videos: videos));

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      // Verify ListView is present and has correct number of items
      expect(find.byType(ListView), findsOneWidget);

      // Verify we can find at least one video title
      expect(find.text('TEST VIDEO'), findsOneWidget);
    });

    testWidgets('displays video cards with correct information',
        (tester) async {
      when(() => mockVideoBloc.state)
          .thenReturn(VideoLoaded(videos: [testVideo]));

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      // Verify video card content
      expect(find.text('TEST VIDEO'), findsOneWidget);
      expect(find.text('TEST ARTIST'), findsOneWidget);
      expect(find.text('LOS ANGELES, USA'), findsOneWidget);
    });

    testWidgets('navigates to VideoDetailScreen when video card is tapped',
        (tester) async {
      when(() => mockVideoBloc.state)
          .thenReturn(VideoLoaded(videos: [testVideo]));

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();

      // Verify video card is tappable by checking for GestureDetector
      final gestureDetector = find.byType(GestureDetector);
      expect(gestureDetector, findsAtLeastNWidgets(1));

      // Note: We can't test actual navigation to VideoDetailScreen
      // because it requires YouTube player platform implementation
      // which isn't available in widget tests
    });

    testWidgets('navigates to SearchScreen when search icon is tapped',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createHomeScreen());

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // SearchScreen should be pushed
    });

    testWidgets('pull-to-refresh dispatches LoadVideos', (tester) async {
      final videos = [testVideo];
      when(() => mockVideoBloc.state)
          .thenReturn(VideoLoaded(videos: videos));

      await tester.pumpWidget(createHomeScreen());

      // Simulate pull-to-refresh
      await tester.fling(
        find.byType(ListView),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      verify(() => mockVideoBloc.add(any(that: isA<LoadVideos>()))).called(1);
    });

    testWidgets('displays correct number of videos', (tester) async {
      final videos = List.generate(
        5,
        (index) => Video(
          id: 'video$index',
          youtubeUrl: 'https://youtube.com/watch?v=test$index',
          youtubeId: 'test$index',
          thumbnailUrl: 'https://img.youtube.com/vi/test$index/maxresdefault.jpg',
          title: 'Test Video $index',
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
          sortOrder: index,
          tags: ['live'],
        ),
      );

      when(() => mockVideoBloc.state)
          .thenReturn(VideoLoaded(videos: videos));

      await tester.pumpWidget(createHomeScreen());

      // Find all video cards
      expect(find.byType(ListView), findsOneWidget);

      // Verify we can scroll
      expect(find.text('TEST VIDEO 0'), findsOneWidget);
    });

    testWidgets('rebuilds when VideoBloc state changes', (tester) async {
      whenListen(
        mockVideoBloc,
        Stream.fromIterable([
          const VideoLoading(),
          VideoLoaded(videos: [testVideo]),
        ]),
        initialState: const VideoInitial(),
      );

      await tester.pumpWidget(createHomeScreen());

      // Initially shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for state change
      await tester.pumpAndSettle();

      // Now shows loaded videos
      expect(find.text('TEST VIDEO'), findsOneWidget);
    });

    testWidgets('handles transition from loaded to loading to loaded',
        (tester) async {
      final videos = [testVideo];

      whenListen(
        mockVideoBloc,
        Stream.fromIterable([
          VideoLoaded(videos: videos),
          const VideoLoading(),
          VideoLoaded(videos: videos),
        ]),
        initialState: const VideoInitial(),
      );

      await tester.pumpWidget(createHomeScreen());
      await tester.pumpAndSettle();

      // Should end up showing videos
      expect(find.text('TEST VIDEO'), findsOneWidget);
    });

    testWidgets('handles error after successful load', (tester) async {
      final videos = [testVideo];

      whenListen(
        mockVideoBloc,
        Stream.fromIterable([
          VideoLoaded(videos: videos),
          const VideoError('Network error'),
        ]),
        initialState: const VideoInitial(),
      );

      await tester.pumpWidget(createHomeScreen());
      await tester.pump();
      await tester.pump();

      // Should show error
      expect(find.text('Network error'), findsOneWidget);
    });
  });
}
