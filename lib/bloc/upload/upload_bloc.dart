// ignore_for_file: unused_field

import 'package:bloc/bloc.dart';
import '../../services/video_service.dart';
import '../../models/video.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final VideoService _videoService;
  String? _currentYoutubeId;
  String? _currentThumbnailUrl;

  UploadBloc({required VideoService videoService})
    : _videoService = videoService,
      super(const UploadInitial()) {
    // Register event handlers
    on<ExtractYouTubeId>(_onExtractYouTubeId);
    on<ValidateForm>(_onValidateForm);
    on<SaveAsDraft>(_onSaveAsDraft);
    on<PublishVideo>(_onPublishVideo);
    on<UploadVideoRequested>(_onUploadVideoRequested);
    on<ResetUpload>(_onResetUpload);
  }

  Future<void> _onExtractYouTubeId(
    ExtractYouTubeId event,
    Emitter<UploadState> emit,
  ) async {
    emit(const ExtractingVideoInfo());

    try {
      // Extract YouTube ID from URL
      final youtubeId = Video.extractYouTubeId(event.url);

      if (youtubeId == null || youtubeId.isEmpty) {
        emit(const UploadError('Invalid YouTube URL'));
        return;
      }

      // Generate thumbnail URL
      final thumbnailUrl = Video.getYouTubeThumbnail(youtubeId);

      // Store for later use
      _currentYoutubeId = youtubeId;
      _currentThumbnailUrl = thumbnailUrl;

      emit(
        VideoInfoExtracted(youtubeId: youtubeId, thumbnailUrl: thumbnailUrl),
      );
    } catch (e) {
      emit(UploadError('Failed to extract video info: ${e.toString()}'));
    }
  }

  Future<void> _onValidateForm(
    ValidateForm event,
    Emitter<UploadState> emit,
  ) async {
    emit(const FormValidating());

    try {
      // Validate YouTube URL
      final youtubeId = Video.extractYouTubeId(event.youtubeUrl);
      if (youtubeId == null || youtubeId.isEmpty) {
        emit(const FormInvalid('Invalid YouTube URL'));
        return;
      }

      // Validate title
      if (event.title.isEmpty) {
        emit(const FormInvalid('Title is required'));
        return;
      }

      // Validate artist
      if (event.artist.isEmpty) {
        emit(const FormInvalid('Artist is required'));
        return;
      }

      // Validate artist ID
      if (event.artistId.isEmpty) {
        emit(const FormInvalid('Artist must be selected'));
        return;
      }

      final thumbnailUrl = Video.getYouTubeThumbnail(youtubeId);

      _currentYoutubeId = youtubeId;
      _currentThumbnailUrl = thumbnailUrl;

      emit(FormValid(youtubeId: youtubeId, thumbnailUrl: thumbnailUrl));
    } catch (e) {
      emit(FormInvalid('Validation error: ${e.toString()}'));
    }
  }

  Future<void> _onSaveAsDraft(
    SaveAsDraft event,
    Emitter<UploadState> emit,
  ) async {
    emit(const Uploading(progress: 0.0, status: 'Saving draft...'));

    try {
      final videoData = Map<String, dynamic>.from(event.videoData);
      videoData['status'] = 'draft';

      await _uploadVideo(videoData, emit, isDraft: true);
    } catch (e) {
      emit(UploadError('Failed to save draft: ${e.toString()}'));
    }
  }

  Future<void> _onPublishVideo(
    PublishVideo event,
    Emitter<UploadState> emit,
  ) async {
    emit(const Uploading(progress: 0.0, status: 'Publishing video...'));

    try {
      final videoData = Map<String, dynamic>.from(event.videoData);
      videoData['status'] = 'published';

      await _uploadVideo(videoData, emit, isDraft: false);
    } catch (e) {
      emit(UploadError('Failed to publish video: ${e.toString()}'));
    }
  }

  Future<void> _onUploadVideoRequested(
    UploadVideoRequested event,
    Emitter<UploadState> emit,
  ) async {
    emit(const Uploading(progress: 0.0, status: 'Uploading...'));

    try {
      await _uploadVideo(event.videoData, emit);
    } catch (e) {
      emit(UploadError('Upload failed: ${e.toString()}'));
    }
  }

  Future<void> _uploadVideo(
    Map<String, dynamic> videoData,
    Emitter<UploadState> emit, {
    bool isDraft = false,
  }) async {
    try {
      // Update progress
      emit(
        Uploading(
          progress: 0.3,
          status: isDraft ? 'Saving draft...' : 'Creating video...',
        ),
      );

      final videoId = await _videoService.addVideo(
        youtubeUrl: videoData['youtubeUrl'] as String,
        title: videoData['title'] as String,
        artist: videoData['artist'] as String,
        artistId: videoData['artistId'] as String,
        description: videoData['description'] as String? ?? '',
        genres: List<String>.from(videoData['genres'] ?? []),
        venue: videoData['venue'] as String? ?? '',
        city: videoData['city'] as String? ?? '',
        country: videoData['country'] as String? ?? '',
        duration: videoData['duration'] as int? ?? 0,
        recordedDate: videoData['recordedDate'] as DateTime?,
        status: videoData['status'] as String? ?? 'draft',
        featured: videoData['featured'] as bool? ?? false,
        sortOrder: videoData['sortOrder'] as int? ?? 0,
        tags: List<String>.from(videoData['tags'] ?? []),
        latitude: videoData['latitude'] as double?,
        longitude: videoData['longitude'] as double?,
        soundcloudUrl: videoData['soundcloudUrl'] as String?,
        spotifyPlaylistId: videoData['spotifyPlaylistId'] as String?,
        appleMusicPlaylistId: videoData['appleMusicPlaylistId'] as String?,
      );

      if (videoId != null) {
        emit(const Uploading(progress: 0.9, status: 'Finalizing...'));

        await Future.delayed(const Duration(milliseconds: 500));

        emit(
          UploadSuccess(
            videoId: videoId,
            message: isDraft
                ? 'Draft saved successfully'
                : 'Video published successfully',
          ),
        );

        // Reset state after success
        _currentYoutubeId = null;
        _currentThumbnailUrl = null;
      } else {
        emit(const UploadError('Failed to create video'));
      }
    } catch (e) {
      emit(UploadError(e.toString()));
    }
  }

  Future<void> _onResetUpload(
    ResetUpload event,
    Emitter<UploadState> emit,
  ) async {
    _currentYoutubeId = null;
    _currentThumbnailUrl = null;
    emit(const UploadInitial());
  }
}
