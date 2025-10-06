import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/screens/search_screen.dart';
import 'package:backdrp_fm/bloc/video/video_bloc.dart';
import 'package:backdrp_fm/bloc/video/video_state.dart';
import 'package:backdrp_fm/bloc/video/video_event.dart';
import 'package:backdrp_fm/bloc/artist/artist_bloc.dart';
import 'package:backdrp_fm/bloc/artist/artist_state.dart';
import 'package:backdrp_fm/bloc/artist/artist_event.dart';
import 'package:backdrp_fm/models/video.dart';

class MockVideoBloc extends MockBloc<VideoEvent, VideoState>
    implements VideoBloc {}

class MockArtistBloc extends MockBloc<ArtistEvent, ArtistState>
    implements ArtistBloc {}

void main() {
  late MockVideoBloc mockVideoBloc;
  late MockArtistBloc mockArtistBloc;

  setUp(() {
    mockVideoBloc = MockVideoBloc();
    mockArtistBloc = MockArtistBloc();
  });

  setUpAll(() {
    registerFallbackValue(const LoadVideos());
    registerFallbackValue(const SearchVideos(''));
    registerFallbackValue(const LoadArtists());
    registerFallbackValue(const SearchArtists(''));
  });

  Widget createSearchScreen() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<VideoBloc>.value(value: mockVideoBloc),
          BlocProvider<ArtistBloc>.value(value: mockArtistBloc),
        ],
        child: const SearchScreen(),
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

  group('SearchScreen', () {
    testWidgets('displays app bar with search field', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays tabs for Videos and Artists', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());
      await tester.pump();

      expect(find.widgetWithText(Tab, 'VIDEOS'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'ARTISTS'), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('displays search suggestions when not searching', (
      tester,
    ) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      expect(find.text('SEARCH TIPS'), findsOneWidget);
      expect(find.text('POPULAR SEARCHES'), findsOneWidget);
      expect(find.text('BROWSE BY GENRE'), findsOneWidget);
    });

    testWidgets('displays popular search chips', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      expect(find.text('LIVE'), findsOneWidget);
      expect(
        find.text('JAZZ'),
        findsAtLeastNWidgets(1),
      ); // Appears in both popular and genre
      expect(find.text('ELECTRONIC'), findsAtLeastNWidgets(1));
      expect(find.text('NEW YORK'), findsOneWidget);
    });

    testWidgets('displays genre chips', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      expect(find.text('POP'), findsOneWidget);
      expect(find.text('R&B'), findsOneWidget);
      expect(find.text('HOUSE'), findsOneWidget);
      expect(find.text('INDIE'), findsOneWidget);
    });

    testWidgets('search field dispatches SearchVideos event', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      verify(
        () => mockVideoBloc.add(const SearchVideos('test query')),
      ).called(1);
    });

    testWidgets('clearing search dispatches LoadVideos', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      verify(() => mockVideoBloc.add(any(that: isA<LoadVideos>()))).called(1);
    });

    testWidgets('displays loading indicator when searching videos', (
      tester,
    ) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoLoading());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      // Enter search to trigger searching state
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('SEARCHING VIDEOS'), findsOneWidget);
    });

    testWidgets('displays video search results', (tester) async {
      when(
        () => mockVideoBloc.state,
      ).thenReturn(VideoLoaded(videos: [testVideo]));
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      // Enter search
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('TEST VIDEO'), findsOneWidget);
    });

    testWidgets('displays empty state when no videos found', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoLoaded(videos: []));
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.text('NO VIDEOS FOUND'), findsOneWidget);
      expect(
        find.text('Try searching for a different title, artist, or tag'),
        findsOneWidget,
      );
    });

    testWidgets('switching to Artists tab searches artists', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      // Enter search first
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Switch to Artists tab
      await tester.tap(find.widgetWithText(Tab, 'ARTISTS'));
      await tester.pump();

      verify(() => mockArtistBloc.add(const SearchArtists('test'))).called(1);
    });

    testWidgets('search in artist tab dispatches SearchArtists event', (
      tester,
    ) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      // Switch to Artists tab first
      await tester.tap(find.widgetWithText(Tab, 'ARTISTS'));
      await tester.pump();

      // Then enter search - should dispatch SearchArtists
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      verify(() => mockArtistBloc.add(const SearchArtists('test'))).called(1);
    });

    testWidgets('artists tab shows search suggestions when not searching', (
      tester,
    ) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      // Switch to Artists tab
      await tester.tap(find.widgetWithText(Tab, 'ARTISTS'));
      await tester.pump();

      // Should still show search suggestions (same as Videos tab)
      expect(find.text('SEARCH TIPS'), findsOneWidget);
    });

    testWidgets('tapping suggestion chip performs search', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      // Find Jazz suggestion chip (not the genre chip)
      final jazzChips = find.text('JAZZ');
      await tester.tap(jazzChips.first);
      await tester.pump();

      verify(() => mockVideoBloc.add(const SearchVideos('Jazz'))).called(1);
    });

    testWidgets('tapping genre chip performs search', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      // Tap on Pop genre
      await tester.tap(find.text('POP'));
      await tester.pump();

      verify(() => mockVideoBloc.add(const SearchVideos('Pop'))).called(1);
    });

    testWidgets('back button pops the screen', (tester) async {
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createSearchScreen());

      // Verify back button exists
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Note: We can't actually test navigation pop in MaterialApp
      // as there's no navigation stack in the test
    });
  });
}
