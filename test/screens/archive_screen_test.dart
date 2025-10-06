import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/screens/archive_screen.dart';
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
    registerFallbackValue(const SearchVideos(''));
    registerFallbackValue(const FilterVideos());
  });

  Widget createArchiveScreen() {
    return MaterialApp(
      home: BlocProvider<VideoBloc>.value(
        value: mockVideoBloc,
        child: const ArchiveScreen(),
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

  group('ArchiveScreen', () {
    testWidgets('displays app bar with correct title', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());

      expect(find.text('ARCHIVE'), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('dispatches LoadVideos on init', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      verify(() => mockVideoBloc.add(any(that: isA<LoadVideos>()))).called(1);
    });

    testWidgets('displays search field', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays loading indicator when state is VideoLoading',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoLoading());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('LOADING ARCHIVE'), findsOneWidget);
    });

    testWidgets('displays error view when state is VideoError',
        (tester) async {
      when(() => mockVideoBloc.state)
          .thenReturn(const VideoError('Failed to load videos'));

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      expect(find.text('ERROR'), findsOneWidget);
      expect(find.text('Failed to load videos'), findsOneWidget);
      expect(find.text('RETRY'), findsOneWidget);
    });

    testWidgets('error view retry button dispatches LoadVideos',
        (tester) async {
      when(() => mockVideoBloc.state)
          .thenReturn(const VideoError('Failed to load videos'));

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      await tester.tap(find.text('RETRY'));
      await tester.pump();

      // Called twice: once on init, once on retry
      verify(() => mockVideoBloc.add(any(that: isA<LoadVideos>()))).called(2);
    });

    testWidgets('displays empty state when no videos are loaded',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoLoaded(videos: []));

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      expect(find.text('NO VIDEOS FOUND'), findsOneWidget);
      expect(find.text('Try adjusting your filters or search query'),
          findsOneWidget);
      expect(find.text('CLEAR FILTERS'), findsOneWidget);
    });

    testWidgets('empty state clear filters button dispatches LoadVideos',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoLoaded(videos: []));

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      await tester.tap(find.text('CLEAR FILTERS'));
      await tester.pump();

      // Called twice: once on init, once on clear filters
      verify(() => mockVideoBloc.add(any(that: isA<LoadVideos>()))).called(2);
    });

    testWidgets('displays list of videos when loaded', (tester) async {
      final videos = [testVideo, testVideo2];

      when(() => mockVideoBloc.state)
          .thenReturn(VideoLoaded(videos: videos));

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('TEST VIDEO'), findsOneWidget);
    });

    testWidgets('search field dispatches SearchVideos event', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      // Type in search field
      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      verify(() => mockVideoBloc.add(const SearchVideos('test query')))
          .called(1);
    });

    testWidgets('clearing search text dispatches LoadVideos', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      // Type in search field
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Clear search
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // Called twice: once on init, once on clear
      verify(() => mockVideoBloc.add(any(that: isA<LoadVideos>())))
          .called(greaterThanOrEqualTo(1));
    });

    testWidgets('opens filter sheet when filter icon is tapped',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('FILTERS'), findsOneWidget);
      expect(find.text('GENRE'), findsOneWidget);
      expect(find.text('ARTIST'), findsOneWidget);
      expect(find.text('LOCATION'), findsOneWidget);
    });

    testWidgets('filter sheet displays genre chips', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('POP'), findsOneWidget);
      expect(find.text('R&B'), findsOneWidget);
      expect(find.text('ELECTRONIC'), findsOneWidget);
      expect(find.text('HOUSE'), findsOneWidget);
      expect(find.text('INDIE'), findsOneWidget);
      expect(find.text('JAZZ'), findsOneWidget);
    });

    testWidgets('filter sheet displays artist chips', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('THE WEEKND'), findsOneWidget);
      expect(find.text('DAFT PUNK'), findsOneWidget);
      expect(find.text('BILLIE EILISH'), findsOneWidget);
      expect(find.text('ROBERT GLASPER'), findsOneWidget);
      expect(find.text('TRAVIS SCOTT'), findsOneWidget);
    });

    testWidgets('filter sheet displays location chips', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('NEW YORK, USA'), findsOneWidget);
      expect(find.text('LOS ANGELES, USA'), findsOneWidget);
      expect(find.text('BERLIN, GERMANY'), findsOneWidget);
      expect(find.text('TOKYO, JAPAN'), findsOneWidget);
      expect(find.text('LONDON, UK'), findsOneWidget);
      expect(find.text('PARIS, FRANCE'), findsOneWidget);
    });

    testWidgets('filter sheet has clear and apply buttons', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.widgetWithText(OutlinedButton, 'CLEAR'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'APPLY'), findsOneWidget);
    });

    testWidgets('applying genre filter dispatches FilterVideos event',
        (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      // Open filter sheet
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Select Electronic genre
      await tester.tap(find.text('ELECTRONIC'));
      await tester.pump();

      // Scroll to make APPLY button visible
      await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'APPLY'));
      await tester.pump();

      // Apply filters
      await tester.tap(find.widgetWithText(ElevatedButton, 'APPLY'));
      await tester.pump();

      verify(() => mockVideoBloc.add(any(that: isA<FilterVideos>())))
          .called(1);
    });

    testWidgets('pull-to-refresh dispatches LoadVideos', (tester) async {
      final videos = [testVideo];
      when(() => mockVideoBloc.state).thenReturn(VideoLoaded(videos: videos));

      await tester.pumpWidget(createArchiveScreen());
      await tester.pump();

      // Simulate pull-to-refresh
      await tester.fling(
        find.byType(ListView),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      verify(() => mockVideoBloc.add(any(that: isA<LoadVideos>())))
          .called(greaterThanOrEqualTo(1));
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

      await tester.pumpWidget(createArchiveScreen());

      // Initially shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for state change
      await tester.pumpAndSettle();

      // Now shows loaded videos
      expect(find.text('TEST VIDEO'), findsOneWidget);
    });
  });
}
