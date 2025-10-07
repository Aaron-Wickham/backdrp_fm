import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../services/video_service.dart';
import '../../models/video.dart';
import 'video_event.dart';
import 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoService _videoService;
  StreamSubscription<List<Video>>? _videoSubscription;
  List<Video> _cachedVideos = [];
  static const int _pageSize = 20;

  VideoBloc({required VideoService videoService})
      : _videoService = videoService,
        super(const VideoInitial()) {
    // Register event handlers
    on<LoadVideos>(_onLoadVideos);
    on<LoadFeaturedVideos>(_onLoadFeaturedVideos);
    on<LoadVideosByArtist>(_onLoadVideosByArtist);
    on<FilterVideos>(_onFilterVideos);
    on<LikeVideo>(_onLikeVideo);
    on<SaveVideo>(_onSaveVideo);
    on<SearchVideos>(_onSearchVideos);
    on<LoadMoreVideos>(_onLoadMoreVideos);
  }

  Future<void> _onLoadVideos(LoadVideos event, Emitter<VideoState> emit) async {
    emit(const VideoLoading());

    try {
      await _videoSubscription?.cancel();

      await emit.forEach<List<Video>>(
        _videoService.getPublishedVideos(),
        onData: (videos) {
          _cachedVideos = videos;
          final hasMore = videos.length >= _pageSize;
          return VideoLoaded(videos: videos, hasReachedMax: !hasMore);
        },
        onError: (error, stackTrace) {
          return VideoError(error.toString());
        },
      );
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> _onLoadFeaturedVideos(
    LoadFeaturedVideos event,
    Emitter<VideoState> emit,
  ) async {
    emit(const VideoLoading());

    try {
      await _videoSubscription?.cancel();

      await emit.forEach<List<Video>>(
        _videoService.getFeaturedVideos(limit: event.limit),
        onData: (videos) {
          _cachedVideos = videos;
          final hasMore = videos.length >= _pageSize;
          return VideoLoaded(videos: videos, hasReachedMax: !hasMore);
        },
        onError: (error, stackTrace) {
          return VideoError(error.toString());
        },
      );
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> _onLoadVideosByArtist(
    LoadVideosByArtist event,
    Emitter<VideoState> emit,
  ) async {
    emit(const VideoLoading());

    try {
      await _videoSubscription?.cancel();

      await emit.forEach<List<Video>>(
        _videoService.getVideosByArtist(event.artistId),
        onData: (videos) {
          _cachedVideos = videos;
          final hasMore = videos.length >= _pageSize;
          return VideoLoaded(videos: videos, hasReachedMax: !hasMore);
        },
        onError: (error, stackTrace) {
          return VideoError(error.toString());
        },
      );
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> _onFilterVideos(
    FilterVideos event,
    Emitter<VideoState> emit,
  ) async {
    emit(const VideoLoading());

    try {
      await _videoSubscription?.cancel();

      // Handle multiple genres by getting first genre if available
      final genre = event.genres != null && event.genres!.isNotEmpty
          ? event.genres!.first
          : null;

      await emit.forEach<List<Video>>(
        _videoService.getFilteredVideos(
          genre: genre,
          artistId: event.artistId,
          fromDate: event.fromDate,
          toDate: event.toDate,
          city: event.city,
          country: event.country,
        ),
        onData: (videos) {
          _cachedVideos = videos;
          final hasMore = videos.length >= _pageSize;
          return VideoLoaded(videos: videos, hasReachedMax: !hasMore);
        },
        onError: (error, stackTrace) {
          return VideoError(error.toString());
        },
      );
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> _onLikeVideo(LikeVideo event, Emitter<VideoState> emit) async {
    try {
      final success = await _videoService.toggleLike(
        event.videoId,
        event.userId,
      );

      if (success) {
        // Videos will be updated via stream
      } else {
        emit(const VideoError('Failed to like video'));
      }
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> _onSaveVideo(SaveVideo event, Emitter<VideoState> emit) async {
    try {
      final success = await _videoService.toggleSave(
        event.videoId,
        event.userId,
      );

      if (success) {
        // Update cached videos to reflect the save state
        if (state is VideoLoaded) {
          emit((state as VideoLoaded).copyWith());
        }
      } else {
        emit(const VideoError('Failed to save video'));
      }
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> _onSearchVideos(
    SearchVideos event,
    Emitter<VideoState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadVideos());
      return;
    }

    emit(const VideoLoading());

    try {
      // Filter cached videos by search query
      final queryLower = event.query.toLowerCase();
      final filteredVideos = _cachedVideos.where((video) {
        return video.title.toLowerCase().contains(queryLower) ||
            video.artist.toLowerCase().contains(queryLower) ||
            video.description.toLowerCase().contains(queryLower) ||
            video.tags.any((tag) => tag.toLowerCase().contains(queryLower));
      }).toList();

      emit(VideoLoaded(videos: filteredVideos, hasReachedMax: true));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }

  Future<void> _onLoadMoreVideos(
    LoadMoreVideos event,
    Emitter<VideoState> emit,
  ) async {
    if (state is VideoLoaded) {
      final currentState = state as VideoLoaded;
      if (currentState.hasReachedMax || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));

      // In a real app, you would implement pagination here
      // For now, we'll just mark as reached max since Firestore streams
      // handle the data automatically
      emit(currentState.copyWith(isLoadingMore: false, hasReachedMax: true));
    }
  }

  @override
  Future<void> close() {
    _videoSubscription?.cancel();
    return super.close();
  }
}
