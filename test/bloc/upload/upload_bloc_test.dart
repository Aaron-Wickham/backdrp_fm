import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:backdrp_fm/bloc/upload/upload_bloc.dart';
import 'package:backdrp_fm/bloc/upload/upload_event.dart';
import 'package:backdrp_fm/bloc/upload/upload_state.dart';
import 'package:backdrp_fm/services/video_service.dart';

@GenerateMocks([VideoService])
import 'upload_bloc_test.mocks.dart';

void main() {
  late UploadBloc uploadBloc;
  late MockVideoService mockVideoService;

  setUp(() {
    mockVideoService = MockVideoService();
    uploadBloc = UploadBloc(videoService: mockVideoService);
  });

  tearDown(() {
    uploadBloc.close();
  });

  group('UploadBloc', () {
    test('initial state is UploadInitial', () {
      expect(uploadBloc.state, const UploadInitial());
    });

    blocTest<UploadBloc, UploadState>(
      'emits [ExtractingVideoInfo, VideoInfoExtracted] when ExtractYouTubeId succeeds',
      build: () => UploadBloc(videoService: mockVideoService),
      act: (bloc) => bloc.add(
        const ExtractYouTubeId('https://youtube.com/watch?v=dQw4w9WgXcQ'),
      ),
      expect: () => [
        const ExtractingVideoInfo(),
        const VideoInfoExtracted(
          youtubeId: 'dQw4w9WgXcQ',
          thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
        ),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits [ExtractingVideoInfo, UploadError] when YouTube URL is invalid',
      build: () => UploadBloc(videoService: mockVideoService),
      act: (bloc) => bloc.add(
        const ExtractYouTubeId('https://invalid.com/video'),
      ),
      expect: () => [
        const ExtractingVideoInfo(),
        const UploadError('Invalid YouTube URL'),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits [FormValidating, FormValid] when ValidateForm succeeds',
      build: () => UploadBloc(videoService: mockVideoService),
      act: (bloc) => bloc.add(
        const ValidateForm(
          youtubeUrl: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
          title: 'Test Video',
          artist: 'Test Artist',
          artistId: 'artist1',
        ),
      ),
      expect: () => [
        const FormValidating(),
        const FormValid(
          youtubeId: 'dQw4w9WgXcQ',
          thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
        ),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits [FormValidating, FormInvalid] when YouTube URL is invalid',
      build: () => UploadBloc(videoService: mockVideoService),
      act: (bloc) => bloc.add(
        const ValidateForm(
          youtubeUrl: 'https://invalid.com/video',
          title: 'Test Video',
          artist: 'Test Artist',
          artistId: 'artist1',
        ),
      ),
      expect: () => [
        const FormValidating(),
        const FormInvalid('Invalid YouTube URL'),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits [FormValidating, FormInvalid] when title is empty',
      build: () => UploadBloc(videoService: mockVideoService),
      act: (bloc) => bloc.add(
        const ValidateForm(
          youtubeUrl: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
          title: '',
          artist: 'Test Artist',
          artistId: 'artist1',
        ),
      ),
      expect: () => [
        const FormValidating(),
        const FormInvalid('Title is required'),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits [FormValidating, FormInvalid] when artist is empty',
      build: () => UploadBloc(videoService: mockVideoService),
      act: (bloc) => bloc.add(
        const ValidateForm(
          youtubeUrl: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
          title: 'Test Video',
          artist: '',
          artistId: 'artist1',
        ),
      ),
      expect: () => [
        const FormValidating(),
        const FormInvalid('Artist is required'),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits [FormValidating, FormInvalid] when artistId is empty',
      build: () => UploadBloc(videoService: mockVideoService),
      act: (bloc) => bloc.add(
        const ValidateForm(
          youtubeUrl: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
          title: 'Test Video',
          artist: 'Test Artist',
          artistId: '',
        ),
      ),
      expect: () => [
        const FormValidating(),
        const FormInvalid('Artist must be selected'),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits upload states when SaveAsDraft succeeds',
      build: () {
        when(mockVideoService.addVideo(
          youtubeUrl: anyNamed('youtubeUrl'),
          title: anyNamed('title'),
          artist: anyNamed('artist'),
          artistId: anyNamed('artistId'),
          description: anyNamed('description'),
          genres: anyNamed('genres'),
          venue: anyNamed('venue'),
          city: anyNamed('city'),
          country: anyNamed('country'),
          duration: anyNamed('duration'),
          recordedDate: anyNamed('recordedDate'),
          status: anyNamed('status'),
          featured: anyNamed('featured'),
          sortOrder: anyNamed('sortOrder'),
          tags: anyNamed('tags'),
          latitude: anyNamed('latitude'),
          longitude: anyNamed('longitude'),
          soundcloudUrl: anyNamed('soundcloudUrl'),
          spotifyPlaylistId: anyNamed('spotifyPlaylistId'),
          appleMusicPlaylistId: anyNamed('appleMusicPlaylistId'),
        )).thenAnswer((_) async => 'video123');
        return UploadBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(SaveAsDraft({
        'youtubeUrl': 'https://youtube.com/watch?v=test',
        'title': 'Test Video',
        'artist': 'Test Artist',
        'artistId': 'artist1',
        'description': 'Test description',
        'genres': ['Electronic'],
        'venue': 'Test Venue',
        'city': 'London',
        'country': 'UK',
        'duration': 3600,
      })),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const Uploading(progress: 0.0, status: 'Saving draft...'),
        const Uploading(progress: 0.3, status: 'Saving draft...'),
        const Uploading(progress: 0.9, status: 'Finalizing...'),
        const UploadSuccess(
          videoId: 'video123',
          message: 'Draft saved successfully',
        ),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits upload states when PublishVideo succeeds',
      build: () {
        when(mockVideoService.addVideo(
          youtubeUrl: anyNamed('youtubeUrl'),
          title: anyNamed('title'),
          artist: anyNamed('artist'),
          artistId: anyNamed('artistId'),
          description: anyNamed('description'),
          genres: anyNamed('genres'),
          venue: anyNamed('venue'),
          city: anyNamed('city'),
          country: anyNamed('country'),
          duration: anyNamed('duration'),
          recordedDate: anyNamed('recordedDate'),
          status: anyNamed('status'),
          featured: anyNamed('featured'),
          sortOrder: anyNamed('sortOrder'),
          tags: anyNamed('tags'),
          latitude: anyNamed('latitude'),
          longitude: anyNamed('longitude'),
          soundcloudUrl: anyNamed('soundcloudUrl'),
          spotifyPlaylistId: anyNamed('spotifyPlaylistId'),
          appleMusicPlaylistId: anyNamed('appleMusicPlaylistId'),
        )).thenAnswer((_) async => 'video123');
        return UploadBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(PublishVideo({
        'youtubeUrl': 'https://youtube.com/watch?v=test',
        'title': 'Test Video',
        'artist': 'Test Artist',
        'artistId': 'artist1',
        'description': 'Test description',
        'genres': ['Electronic'],
        'venue': 'Test Venue',
        'city': 'London',
        'country': 'UK',
        'duration': 3600,
      })),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const Uploading(progress: 0.0, status: 'Publishing video...'),
        const Uploading(progress: 0.3, status: 'Creating video...'),
        const Uploading(progress: 0.9, status: 'Finalizing...'),
        const UploadSuccess(
          videoId: 'video123',
          message: 'Video published successfully',
        ),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits UploadError when video upload fails',
      build: () {
        when(mockVideoService.addVideo(
          youtubeUrl: anyNamed('youtubeUrl'),
          title: anyNamed('title'),
          artist: anyNamed('artist'),
          artistId: anyNamed('artistId'),
          description: anyNamed('description'),
          genres: anyNamed('genres'),
          venue: anyNamed('venue'),
          city: anyNamed('city'),
          country: anyNamed('country'),
          duration: anyNamed('duration'),
          recordedDate: anyNamed('recordedDate'),
          status: anyNamed('status'),
          featured: anyNamed('featured'),
          sortOrder: anyNamed('sortOrder'),
          tags: anyNamed('tags'),
          latitude: anyNamed('latitude'),
          longitude: anyNamed('longitude'),
          soundcloudUrl: anyNamed('soundcloudUrl'),
          spotifyPlaylistId: anyNamed('spotifyPlaylistId'),
          appleMusicPlaylistId: anyNamed('appleMusicPlaylistId'),
        )).thenAnswer((_) async => null);
        return UploadBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(PublishVideo({
        'youtubeUrl': 'https://youtube.com/watch?v=test',
        'title': 'Test Video',
        'artist': 'Test Artist',
        'artistId': 'artist1',
        'description': 'Test description',
        'genres': ['Electronic'],
      })),
      expect: () => [
        const Uploading(progress: 0.0, status: 'Publishing video...'),
        const Uploading(progress: 0.3, status: 'Creating video...'),
        const UploadError('Failed to create video'),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits UploadInitial when ResetUpload is added',
      build: () => UploadBloc(videoService: mockVideoService),
      seed: () => const UploadSuccess(videoId: 'video123'),
      act: (bloc) => bloc.add(const ResetUpload()),
      expect: () => [
        const UploadInitial(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits upload states when UploadVideoRequested succeeds',
      build: () {
        when(mockVideoService.addVideo(
          youtubeUrl: anyNamed('youtubeUrl'),
          title: anyNamed('title'),
          artist: anyNamed('artist'),
          artistId: anyNamed('artistId'),
          description: anyNamed('description'),
          genres: anyNamed('genres'),
          venue: anyNamed('venue'),
          city: anyNamed('city'),
          country: anyNamed('country'),
          duration: anyNamed('duration'),
          recordedDate: anyNamed('recordedDate'),
          status: anyNamed('status'),
          featured: anyNamed('featured'),
          sortOrder: anyNamed('sortOrder'),
          tags: anyNamed('tags'),
          latitude: anyNamed('latitude'),
          longitude: anyNamed('longitude'),
          soundcloudUrl: anyNamed('soundcloudUrl'),
          spotifyPlaylistId: anyNamed('spotifyPlaylistId'),
          appleMusicPlaylistId: anyNamed('appleMusicPlaylistId'),
        )).thenAnswer((_) async => 'video123');
        return UploadBloc(videoService: mockVideoService);
      },
      act: (bloc) => bloc.add(UploadVideoRequested({
        'youtubeUrl': 'https://youtube.com/watch?v=test',
        'title': 'Test Video',
        'artist': 'Test Artist',
        'artistId': 'artist1',
        'description': 'Test description',
        'genres': ['Electronic'],
        'status': 'draft',
      })),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const Uploading(progress: 0.0, status: 'Uploading...'),
        const Uploading(progress: 0.3, status: 'Creating video...'),
        const Uploading(progress: 0.9, status: 'Finalizing...'),
        const UploadSuccess(
          videoId: 'video123',
          message: 'Video published successfully',
        ),
      ],
    );
  });
}
