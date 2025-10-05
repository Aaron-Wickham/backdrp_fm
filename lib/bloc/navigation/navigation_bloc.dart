import 'package:bloc/bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationHome()) {
    // Register event handlers
    on<NavigateToHome>(_onNavigateToHome);
    on<NavigateToArchive>(_onNavigateToArchive);
    on<NavigateToArtists>(_onNavigateToArtists);
    on<NavigateToProfile>(_onNavigateToProfile);
    on<NavigateToVideo>(_onNavigateToVideo);
    on<NavigateToArtist>(_onNavigateToArtist);
    on<NavigateToPlaylist>(_onNavigateToPlaylist);
    on<NavigateToSettings>(_onNavigateToSettings);
    on<NavigateBack>(_onNavigateBack);
    on<HandleDeepLink>(_onHandleDeepLink);
    on<SetCurrentIndex>(_onSetCurrentIndex);
  }

  void _onNavigateToHome(
    NavigateToHome event,
    Emitter<NavigationState> emit,
  ) {
    emit(const NavigationHome());
  }

  void _onNavigateToArchive(
    NavigateToArchive event,
    Emitter<NavigationState> emit,
  ) {
    emit(const NavigationArchive());
  }

  void _onNavigateToArtists(
    NavigateToArtists event,
    Emitter<NavigationState> emit,
  ) {
    emit(const NavigationArtists());
  }

  void _onNavigateToProfile(
    NavigateToProfile event,
    Emitter<NavigationState> emit,
  ) {
    emit(const NavigationProfile());
  }

  void _onNavigateToVideo(
    NavigateToVideo event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationDetail(
      type: NavigationType.video,
      id: event.videoId,
      previousIndex: state.currentIndex,
    ));
  }

  void _onNavigateToArtist(
    NavigateToArtist event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationDetail(
      type: NavigationType.artist,
      id: event.artistId,
      previousIndex: state.currentIndex,
    ));
  }

  void _onNavigateToPlaylist(
    NavigateToPlaylist event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationDetail(
      type: NavigationType.playlist,
      id: event.playlistId,
      previousIndex: state.currentIndex,
    ));
  }

  void _onNavigateToSettings(
    NavigateToSettings event,
    Emitter<NavigationState> emit,
  ) {
    emit(NavigationSettings(previousIndex: state.currentIndex));
  }

  void _onNavigateBack(
    NavigateBack event,
    Emitter<NavigationState> emit,
  ) {
    // Navigate back to the previous index
    if (state is NavigationDetail) {
      final detailState = state as NavigationDetail;
      _navigateToIndex(detailState.previousIndex, emit);
    } else if (state is NavigationSettings) {
      final settingsState = state as NavigationSettings;
      _navigateToIndex(settingsState.previousIndex, emit);
    } else {
      // Default to home if no previous state
      emit(const NavigationHome());
    }
  }

  void _onHandleDeepLink(
    HandleDeepLink event,
    Emitter<NavigationState> emit,
  ) {
    // Parse deep link and navigate accordingly
    final uri = Uri.tryParse(event.deepLink);
    if (uri == null) return;

    // Handle different deep link patterns
    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return;

    switch (pathSegments[0]) {
      case 'video':
        if (pathSegments.length > 1) {
          emit(NavigationDetail(
            type: NavigationType.video,
            id: pathSegments[1],
            previousIndex: state.currentIndex,
          ));
        }
        break;
      case 'artist':
        if (pathSegments.length > 1) {
          emit(NavigationDetail(
            type: NavigationType.artist,
            id: pathSegments[1],
            previousIndex: state.currentIndex,
          ));
        }
        break;
      case 'playlist':
        if (pathSegments.length > 1) {
          emit(NavigationDetail(
            type: NavigationType.playlist,
            id: pathSegments[1],
            previousIndex: state.currentIndex,
          ));
        }
        break;
      case 'home':
        emit(const NavigationHome());
        break;
      case 'archive':
        emit(const NavigationArchive());
        break;
      case 'artists':
        emit(const NavigationArtists());
        break;
      case 'profile':
        emit(const NavigationProfile());
        break;
      default:
        // Unknown deep link, navigate to home
        emit(const NavigationHome());
    }
  }

  void _onSetCurrentIndex(
    SetCurrentIndex event,
    Emitter<NavigationState> emit,
  ) {
    _navigateToIndex(event.index, emit);
  }

  void _navigateToIndex(int index, Emitter<NavigationState> emit) {
    switch (index) {
      case 0:
        emit(const NavigationHome());
        break;
      case 1:
        emit(const NavigationArchive());
        break;
      case 2:
        emit(const NavigationArtists());
        break;
      case 3:
        emit(const NavigationProfile());
        break;
      default:
        emit(const NavigationHome());
    }
  }
}
