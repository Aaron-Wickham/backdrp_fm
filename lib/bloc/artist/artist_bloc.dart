import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../services/artist_service.dart';
import '../../services/video_service.dart';
import '../../models/artist.dart';
import '../../models/video.dart';
import 'artist_event.dart';
import 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final ArtistService _artistService;
  final VideoService _videoService;
  StreamSubscription<List<Artist>>? _artistSubscription;
  StreamSubscription<List<Video>>? _videoSubscription;

  ArtistBloc({
    required ArtistService artistService,
    required VideoService videoService,
  })  : _artistService = artistService,
        _videoService = videoService,
        super(const ArtistInitial()) {
    // Register event handlers
    on<LoadArtists>(_onLoadArtists);
    on<LoadArtistById>(_onLoadArtistById);
    on<FilterByGenre>(_onFilterByGenre);
    on<SearchArtists>(_onSearchArtists);
    on<RefreshArtists>(_onRefreshArtists);
  }

  Future<void> _onLoadArtists(
    LoadArtists event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistLoading());

    try {
      await _artistSubscription?.cancel();
      await emit.forEach<List<Artist>>(
        _artistService.getActiveArtists(),
        onData: (artists) {
          return ArtistsLoaded(artists: artists);
        },
        onError: (error, stackTrace) {
          return ArtistError(error.toString());
        },
      );
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }

  Future<void> _onLoadArtistById(
    LoadArtistById event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistLoading());

    try {
      // Load artist details
      final artist = await _artistService.getArtist(event.artistId);

      if (artist == null) {
        emit(const ArtistError('Artist not found'));
        return;
      }

      // Load artist's videos
      await _videoSubscription?.cancel();
      await emit.forEach<List<Video>>(
        _videoService.getVideosByArtist(event.artistId),
        onData: (videos) {
          return ArtistDetailLoaded(
            artist: artist,
            videos: videos,
          );
        },
        onError: (error, stackTrace) {
          return ArtistError(error.toString());
        },
      );
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }

  Future<void> _onFilterByGenre(
    FilterByGenre event,
    Emitter<ArtistState> emit,
  ) async {
    emit(const ArtistLoading());

    try {
      await _artistSubscription?.cancel();
      await emit.forEach<List<Artist>>(
        _artistService.getArtistsByGenre(event.genre),
        onData: (artists) {
          return ArtistsLoaded(artists: artists);
        },
        onError: (error, stackTrace) {
          return ArtistError(error.toString());
        },
      );
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }

  Future<void> _onSearchArtists(
    SearchArtists event,
    Emitter<ArtistState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadArtists());
      return;
    }

    emit(const ArtistLoading());

    try {
      await _artistSubscription?.cancel();
      await emit.forEach<List<Artist>>(
        _artistService.searchArtists(event.query),
        onData: (artists) {
          return ArtistsLoaded(artists: artists);
        },
        onError: (error, stackTrace) {
          return ArtistError(error.toString());
        },
      );
    } catch (e) {
      emit(ArtistError(e.toString()));
    }
  }

  Future<void> _onRefreshArtists(
    RefreshArtists event,
    Emitter<ArtistState> emit,
  ) async {
    add(const LoadArtists());
  }

  @override
  Future<void> close() {
    _artistSubscription?.cancel();
    _videoSubscription?.cancel();
    return super.close();
  }
}
