import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:backdrp_fm/bloc/video/video_bloc.dart';
import 'package:backdrp_fm/bloc/video/video_event.dart';
import 'package:backdrp_fm/bloc/video/video_state.dart';
import 'package:backdrp_fm/services/video_service.dart';
import 'package:backdrp_fm/models/video.dart';

@GenerateMocks([VideoService])
import 'video_bloc_test.mocks.dart';

void main() {
  late VideoBloc videoBloc;
  late MockVideoService mockVideoService;
  late List<Video> testVideos;

  setUp(() {
    mockVideoService = MockVideoService();

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
        artist: 'Test Artist',
        artistId: 'artist1',
        description: 'Test description',
        genres: ['Electronic'],
        location: testLocation,
        duration: 3600,
        status: 'published',
      ),
      Video(
        id: 'video2',
        youtubeUrl: 'https://youtube.com/watch?v=test2',
        youtubeId: 'test2',
        thumbnailUrl: 'https://img.youtube.com/vi/test2/maxresdefault.jpg',
        title: 'Test Video 2',
        artist: 'Test Artist',
        artistId: 'artist1',
        description: 'Another test',
        genres: ['House'],
        location: testLocation,
        duration: 3600,
        status: 'published',
      ),
    ];

    videoBloc = VideoBloc(videoService: mockVideoService);
  });

  tearDown(() {
    videoBloc.close();
  });

  group('VideoBloc', () {
    test('initial state is VideoInitial', () {
      expect(videoBloc.state, const VideoInitial());
    });

    blocTest<VideoBloc, VideoState>(
      'emits [VideoLoading, VideoLoaded] when LoadVideos succeeds',
      build: () {
        when(mockVideoService.getPublishedVideos())
            .thenAnswer((_) => Stream.value(testVideos));
        return VideoBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(const LoadVideos()),
      expect: () => [
        const VideoLoading(),
        // hasReachedMax is true because we have 2 videos which is less than pageSize (20)
        VideoLoaded(videos: testVideos, hasReachedMax: true),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'emits [VideoLoading, VideoError] when LoadVideos fails',
      build: () {
        when(mockVideoService.getPublishedVideos())
            .thenAnswer((_) => Stream.error(Exception('Failed to load')));
        return VideoBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(const LoadVideos()),
      expect: () => [
        const VideoLoading(),
        isA<VideoError>(),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'emits [VideoLoading, VideoLoaded] when LoadFeaturedVideos succeeds',
      build: () {
        when(mockVideoService.getFeaturedVideos(limit: 5))
            .thenAnswer((_) => Stream.value([testVideos.first]));
        return VideoBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(const LoadFeaturedVideos(limit: 5)),
      expect: () => [
        const VideoLoading(),
        VideoLoaded(videos: [testVideos.first], hasReachedMax: true),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'emits [VideoLoading, VideoLoaded] when LoadVideosByArtist succeeds',
      build: () {
        when(mockVideoService.getVideosByArtist('artist1'))
            .thenAnswer((_) => Stream.value(testVideos));
        return VideoBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(const LoadVideosByArtist('artist1')),
      expect: () => [
        const VideoLoading(),
        // hasReachedMax is true because we have 2 videos which is less than pageSize (20)
        VideoLoaded(videos: testVideos, hasReachedMax: true),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'emits [VideoLoading, VideoLoaded] when FilterVideos with genre',
      build: () {
        when(mockVideoService.getFilteredVideos(
          genre: 'Electronic',
          artistId: null,
          fromDate: null,
          toDate: null,
          city: null,
          country: null,
        )).thenAnswer((_) => Stream.value([testVideos.first]));
        return VideoBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(const FilterVideos(genres: ['Electronic'])),
      expect: () => [
        const VideoLoading(),
        VideoLoaded(videos: [testVideos.first], hasReachedMax: true),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'does nothing when LikeVideo succeeds',
      build: () {
        when(mockVideoService.toggleLike('video1', 'user1'))
            .thenAnswer((_) async => true);
        return VideoBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(const LikeVideo(videoId: 'video1', userId: 'user1')),
      expect: () => [],
    );

    blocTest<VideoBloc, VideoState>(
      'emits [VideoError] when LikeVideo fails',
      build: () {
        when(mockVideoService.toggleLike('video1', 'user1'))
            .thenAnswer((_) async => false);
        return VideoBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(const LikeVideo(videoId: 'video1', userId: 'user1')),
      expect: () => [
        const VideoError('Failed to like video'),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'SearchVideos with empty query reloads videos',
      build: () {
        when(mockVideoService.getPublishedVideos())
            .thenAnswer((_) => Stream.value(testVideos));
        return VideoBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(const SearchVideos('')),
      expect: () => [
        const VideoLoading(),
        // hasReachedMax is true because we have 2 videos which is less than pageSize (20)
        VideoLoaded(videos: testVideos, hasReachedMax: true),
      ],
    );
  });
}
