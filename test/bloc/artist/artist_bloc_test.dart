import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:backdrp_fm/bloc/artist/artist_bloc.dart';
import 'package:backdrp_fm/bloc/artist/artist_event.dart';
import 'package:backdrp_fm/bloc/artist/artist_state.dart';
import 'package:backdrp_fm/services/artist_service.dart';
import 'package:backdrp_fm/services/video_service.dart';
import 'package:backdrp_fm/models/artist.dart';
import 'package:backdrp_fm/models/video.dart';

@GenerateMocks([ArtistService, VideoService])
import 'artist_bloc_test.mocks.dart';

void main() {
  late ArtistBloc artistBloc;
  late MockArtistService mockArtistService;
  late MockVideoService mockVideoService;
  late List<Artist> testArtists;
  late List<Video> testVideos;

  setUp(() {
    mockArtistService = MockArtistService();
    mockVideoService = MockVideoService();

    testArtists = [
      Artist(
        id: 'artist1',
        name: 'Test Artist 1',
        bio: 'Bio 1',
        genres: ['Electronic'],
        location: 'London',
        totalSets: 10,
      ),
      Artist(
        id: 'artist2',
        name: 'Test Artist 2',
        bio: 'Bio 2',
        genres: ['House'],
        location: 'Berlin',
        totalSets: 5,
      ),
    ];

    final testLocation = VideoLocation(
      venue: 'Test Venue',
      city: 'London',
      country: 'UK',
    );

    testVideos = [
      Video(
        id: 'video1',
        youtubeUrl: 'https://youtube.com/watch?v=test1',
        youtubeId: 'test1',
        thumbnailUrl: 'https://img.youtube.com/vi/test1/maxresdefault.jpg',
        title: 'Test Video 1',
        artist: 'Test Artist 1',
        artistId: 'artist1',
        description: 'Test description',
        genres: ['Electronic'],
        location: testLocation,
        duration: 3600,
        status: 'published',
      ),
    ];

    artistBloc = ArtistBloc(
      artistService: mockArtistService,
      videoService: mockVideoService,
    );
  });

  tearDown(() {
    artistBloc.close();
  });

  group('ArtistBloc', () {
    test('initial state is ArtistInitial', () {
      expect(artistBloc.state, const ArtistInitial());
    });

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistLoading, ArtistsLoaded] when LoadArtists succeeds',
      build: () {
        when(mockArtistService.getActiveArtists())
            .thenAnswer((_) => Stream.value(testArtists));
        return ArtistBloc(
          artistService: mockArtistService,
          videoService: mockVideoService,
        );
      },
      act: (bloc) => bloc.add(const LoadArtists()),
      expect: () => [
        const ArtistLoading(),
        ArtistsLoaded(artists: testArtists),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistLoading, ArtistError] when LoadArtists fails',
      build: () {
        when(mockArtistService.getActiveArtists())
            .thenAnswer((_) => Stream.error(Exception('Failed to load')));
        return ArtistBloc(
          artistService: mockArtistService,
          videoService: mockVideoService,
        );
      },
      act: (bloc) => bloc.add(const LoadArtists()),
      expect: () => [
        const ArtistLoading(),
        isA<ArtistError>(),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistLoading, ArtistDetailLoaded] when LoadArtistById succeeds',
      build: () {
        when(mockArtistService.getArtist('artist1'))
            .thenAnswer((_) async => testArtists.first);
        when(mockVideoService.getVideosByArtist('artist1'))
            .thenAnswer((_) => Stream.value(testVideos));
        return ArtistBloc(
          artistService: mockArtistService,
          videoService: mockVideoService,
        );
      },
      act: (bloc) => bloc.add(const LoadArtistById('artist1')),
      expect: () => [
        const ArtistLoading(),
        ArtistDetailLoaded(
          artist: testArtists.first,
          videos: testVideos,
        ),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistLoading, ArtistError] when artist not found',
      build: () {
        when(mockArtistService.getArtist('invalid'))
            .thenAnswer((_) async => null);
        return ArtistBloc(
          artistService: mockArtistService,
          videoService: mockVideoService,
        );
      },
      act: (bloc) => bloc.add(const LoadArtistById('invalid')),
      expect: () => [
        const ArtistLoading(),
        const ArtistError('Artist not found'),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistLoading, ArtistsLoaded] when FilterByGenre succeeds',
      build: () {
        when(mockArtistService.getArtistsByGenre('Electronic'))
            .thenAnswer((_) => Stream.value([testArtists.first]));
        return ArtistBloc(
          artistService: mockArtistService,
          videoService: mockVideoService,
        );
      },
      act: (bloc) => bloc.add(const FilterByGenre('Electronic')),
      expect: () => [
        const ArtistLoading(),
        ArtistsLoaded(artists: [testArtists.first]),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'emits [ArtistLoading, ArtistsLoaded] when SearchArtists succeeds',
      build: () {
        when(mockArtistService.searchArtists('Test'))
            .thenAnswer((_) => Stream.value(testArtists));
        return ArtistBloc(
          artistService: mockArtistService,
          videoService: mockVideoService,
        );
      },
      act: (bloc) => bloc.add(const SearchArtists('Test')),
      expect: () => [
        const ArtistLoading(),
        ArtistsLoaded(artists: testArtists),
      ],
    );

    blocTest<ArtistBloc, ArtistState>(
      'dispatches LoadArtists when SearchArtists with empty query',
      build: () {
        when(mockArtistService.getActiveArtists())
            .thenAnswer((_) => Stream.value(testArtists));
        return ArtistBloc(
          artistService: mockArtistService,
          videoService: mockVideoService,
        );
      },
      act: (bloc) => bloc.add(const SearchArtists('')),
      expect: () => [
        const ArtistLoading(),
        ArtistsLoaded(artists: testArtists),
      ],
    );
  });
}
