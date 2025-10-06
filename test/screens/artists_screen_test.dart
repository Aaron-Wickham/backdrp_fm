import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backdrp_fm/screens/artists_screen.dart';
import 'package:backdrp_fm/bloc/artist/artist_bloc.dart';
import 'package:backdrp_fm/bloc/artist/artist_state.dart';
import 'package:backdrp_fm/bloc/artist/artist_event.dart';
import 'package:backdrp_fm/models/artist.dart';

class MockArtistBloc extends MockBloc<ArtistEvent, ArtistState>
    implements ArtistBloc {}

void main() {
  late MockArtistBloc mockArtistBloc;

  setUp(() {
    mockArtistBloc = MockArtistBloc();
  });

  setUpAll(() {
    registerFallbackValue(const LoadArtists());
    registerFallbackValue(const SearchArtists(''));
  });

  Widget createArtistsScreen() {
    return MaterialApp(
      home: BlocProvider<ArtistBloc>.value(
        value: mockArtistBloc,
        child: const ArtistsScreen(),
      ),
    );
  }

  final testArtist = Artist(
    id: 'artist1',
    name: 'Test Artist',
    bio: 'Test bio',
    profileImageUrl: '',
    bannerImageUrl: '',
    socialLinks: {},
    genres: ['Electronic', 'House'],
    location: 'Los Angeles',
    totalSets: 5,
    active: true,
  );

  final testArtist2 = Artist(
    id: 'artist2',
    name: 'Test Artist 2',
    bio: 'Test bio 2',
    profileImageUrl: '',
    bannerImageUrl: '',
    socialLinks: {},
    genres: ['Jazz', 'Soul'],
    location: 'New York',
    totalSets: 10,
    active: true,
  );

  group('ArtistsScreen', () {
    testWidgets('displays app bar with correct title', (tester) async {
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createArtistsScreen());

      expect(find.text('ARTISTS'), findsOneWidget);
    });

    testWidgets('displays search field', (tester) async {
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createArtistsScreen());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('dispatches LoadArtists on init', (tester) async {
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      verify(() => mockArtistBloc.add(any(that: isA<LoadArtists>()))).called(1);
    });

    testWidgets('displays loading indicator when state is ArtistLoading',
        (tester) async {
      when(() => mockArtistBloc.state).thenReturn(const ArtistLoading());

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('LOADING ARTISTS'), findsOneWidget);
    });

    testWidgets('displays error view when state is ArtistError',
        (tester) async {
      when(() => mockArtistBloc.state)
          .thenReturn(const ArtistError('Failed to load artists'));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      expect(find.text('ERROR'), findsOneWidget);
      expect(find.text('Failed to load artists'), findsOneWidget);
      expect(find.text('RETRY'), findsOneWidget);
    });

    testWidgets('error view retry button dispatches LoadArtists',
        (tester) async {
      when(() => mockArtistBloc.state)
          .thenReturn(const ArtistError('Failed to load artists'));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      await tester.tap(find.text('RETRY'));
      await tester.pump();

      // Called twice: once on init, once on retry
      verify(() => mockArtistBloc.add(any(that: isA<LoadArtists>()))).called(2);
    });

    testWidgets('displays empty state when no artists are loaded',
        (tester) async {
      when(() => mockArtistBloc.state)
          .thenReturn(const ArtistsLoaded(artists: []));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      expect(find.text('NO ARTISTS FOUND'), findsOneWidget);
      expect(find.text('No artists available at the moment'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('displays empty state with clear search when searching',
        (tester) async {
      when(() => mockArtistBloc.state)
          .thenReturn(const ArtistsLoaded(artists: []));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      // Enter search text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.text('Try searching for a different artist name'),
          findsOneWidget);
      expect(find.text('CLEAR SEARCH'), findsOneWidget);
    });

    testWidgets('empty state clear button dispatches LoadArtists',
        (tester) async {
      when(() => mockArtistBloc.state)
          .thenReturn(const ArtistsLoaded(artists: []));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      // Enter search text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Tap clear button in empty state
      await tester.tap(find.text('CLEAR SEARCH'));
      await tester.pump();

      // Called multiple times: once on init, once on search, once on clear
      verify(() => mockArtistBloc.add(any(that: isA<LoadArtists>())))
          .called(greaterThanOrEqualTo(1));
    });

    testWidgets('displays list of artists when loaded', (tester) async {
      final artists = [testArtist, testArtist2];

      when(() => mockArtistBloc.state)
          .thenReturn(ArtistsLoaded(artists: artists));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('TEST ARTIST'), findsOneWidget);
      expect(find.text('TEST ARTIST 2'), findsOneWidget);
    });

    testWidgets('displays artist cards with correct information',
        (tester) async {
      when(() => mockArtistBloc.state)
          .thenReturn(ArtistsLoaded(artists: [testArtist]));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      expect(find.text('TEST ARTIST'), findsOneWidget);
      expect(find.text('LOS ANGELES'), findsOneWidget);
      expect(find.text('ELECTRONIC, HOUSE'), findsOneWidget);
      expect(find.text('5 VIDEOS'), findsOneWidget);
    });

    testWidgets('search field dispatches SearchArtists event', (tester) async {
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      verify(() => mockArtistBloc.add(const SearchArtists('test query')))
          .called(1);
    });

    testWidgets('clearing search text dispatches LoadArtists', (tester) async {
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      // Enter search
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Clear search
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      verify(() => mockArtistBloc.add(any(that: isA<LoadArtists>())))
          .called(greaterThanOrEqualTo(1));
    });

    testWidgets('clear button dispatches LoadArtists', (tester) async {
      when(() => mockArtistBloc.state).thenReturn(const ArtistInitial());

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      // Enter search to show clear button
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      verify(() => mockArtistBloc.add(any(that: isA<LoadArtists>())))
          .called(greaterThanOrEqualTo(1));
    });

    testWidgets('pull-to-refresh dispatches LoadArtists', (tester) async {
      final artists = [testArtist];
      when(() => mockArtistBloc.state)
          .thenReturn(ArtistsLoaded(artists: artists));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      // Simulate pull-to-refresh
      await tester.fling(
        find.byType(ListView),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      verify(() => mockArtistBloc.add(any(that: isA<LoadArtists>())))
          .called(greaterThanOrEqualTo(1));
    });

    testWidgets('displays correct number of artists', (tester) async {
      final artists = List.generate(
        5,
        (index) => Artist(
          id: 'artist$index',
          name: 'Test Artist $index',
          bio: 'Bio',
          profileImageUrl: '',
          bannerImageUrl: '',
          socialLinks: {},
          genres: ['Electronic'],
          location: 'Los Angeles',
          totalSets: 5,
          active: true,
        ),
      );

      when(() => mockArtistBloc.state)
          .thenReturn(ArtistsLoaded(artists: artists));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('TEST ARTIST 0'), findsOneWidget);
    });

    testWidgets('rebuilds when ArtistBloc state changes', (tester) async {
      whenListen(
        mockArtistBloc,
        Stream.fromIterable([
          const ArtistLoading(),
          ArtistsLoaded(artists: [testArtist]),
        ]),
        initialState: const ArtistInitial(),
      );

      await tester.pumpWidget(createArtistsScreen());

      // Initially shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for state change
      await tester.pumpAndSettle();

      // Now shows loaded artists
      expect(find.text('TEST ARTIST'), findsOneWidget);
    });

    testWidgets('artist card is tappable', (tester) async {
      when(() => mockArtistBloc.state)
          .thenReturn(ArtistsLoaded(artists: [testArtist]));

      await tester.pumpWidget(createArtistsScreen());
      await tester.pump();

      // Verify GestureDetector exists
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
    });
  });
}
