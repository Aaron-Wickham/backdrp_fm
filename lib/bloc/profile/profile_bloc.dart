import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../services/user_service.dart';
import '../../models/app_user.dart';
import '../../models/video.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService _userService;
  StreamSubscription<AppUser?>? _profileSubscription;
  StreamSubscription<List<Video>>? _likedVideosSubscription;
  StreamSubscription<List<Video>>? _savedVideosSubscription;

  AppUser? _currentUser;
  List<Video> _likedVideos = [];
  List<Video> _savedVideos = [];

  ProfileBloc({required UserService userService})
      : _userService = userService,
        super(const ProfileInitial()) {
    // Register event handlers
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<LoadLikedVideos>(_onLoadLikedVideos);
    on<LoadSavedVideos>(_onLoadSavedVideos);
    on<UpdateNotificationSettings>(_onUpdateNotificationSettings);
    on<ToggleEmailSubscription>(_onToggleEmailSubscription);
    on<TogglePushSubscription>(_onTogglePushSubscription);
    on<UpdateFavoriteGenres>(_onUpdateFavoriteGenres);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    try {
      // Cancel existing subscriptions
      await _profileSubscription?.cancel();
      await _likedVideosSubscription?.cancel();
      await _savedVideosSubscription?.cancel();

      // Listen to profile changes
      _profileSubscription = _userService.getUserProfile(event.userId).listen(
        (user) {
          if (user != null) {
            _currentUser = user;
            if (!isClosed) {
              add(RefreshProfile());
            }
          }
        },
        onError: (error) {
          if (!isClosed) {
            add(RefreshProfile());
          }
        },
      );

      // Listen to liked videos
      _likedVideosSubscription =
          _userService.getUserLikedVideos(event.userId).listen(
        (videos) {
          _likedVideos = videos;
          if (_currentUser != null && !isClosed) {
            add(RefreshProfile());
          }
        },
      );

      // Listen to saved videos
      _savedVideosSubscription =
          _userService.getUserSavedVideos(event.userId).listen(
        (videos) {
          _savedVideos = videos;
          if (_currentUser != null && !isClosed) {
            add(RefreshProfile());
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentUser == null) return;

    if (!emit.isDone) {
      emit(ProfileUpdating(user: _currentUser!));
    }

    try {
      final success = await _userService.updateUserProfile(
        event.userId,
        displayName: event.displayName,
        profileImageUrl: event.profileImageUrl,
      );

      if (success) {
        // Profile will be updated via stream
      } else {
        if (!emit.isDone) {
          emit(const ProfileError('Failed to update profile'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onLoadLikedVideos(
    LoadLikedVideos event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _likedVideosSubscription?.cancel();
      _likedVideosSubscription =
          _userService.getUserLikedVideos(event.userId).listen(
        (videos) {
          _likedVideos = videos;
          if (_currentUser != null && !isClosed) {
            add(RefreshProfile());
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onLoadSavedVideos(
    LoadSavedVideos event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _savedVideosSubscription?.cancel();
      _savedVideosSubscription =
          _userService.getUserSavedVideos(event.userId).listen(
        (videos) {
          _savedVideos = videos;
          if (_currentUser != null && !isClosed) {
            add(RefreshProfile());
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettings event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentUser == null) return;

    if (!emit.isDone) {
      emit(ProfileUpdating(
        user: _currentUser!,
        message: 'Updating notification settings...',
      ));
    }

    try {
      // Update notification preferences
      final prefsSuccess = await _userService.updateNotificationPreferences(
        event.userId,
        newSets: event.newSets,
        artistUpdates: event.artistUpdates,
        weeklyDigest: event.weeklyDigest,
      );

      // Update email subscription if provided
      if (event.emailSubscribed != null) {
        await _userService.subscribeToEmail(
          event.userId,
          event.emailSubscribed!,
        );
      }

      // Update push subscription if provided
      if (event.pushSubscribed != null) {
        await _userService.subscribeToPush(
          event.userId,
          event.pushSubscribed!,
        );
      }

      if (prefsSuccess) {
        // Profile will be updated via stream
      } else {
        if (!emit.isDone) {
          emit(const ProfileError('Failed to update notification settings'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onToggleEmailSubscription(
    ToggleEmailSubscription event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentUser == null) return;

    if (!emit.isDone) {
      emit(ProfileUpdating(
        user: _currentUser!,
        message: 'Updating email subscription...',
      ));
    }

    try {
      final success = await _userService.subscribeToEmail(
        event.userId,
        event.subscribe,
      );

      if (success) {
        // Profile will be updated via stream
      } else {
        if (!emit.isDone) {
          emit(const ProfileError('Failed to update email subscription'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onTogglePushSubscription(
    TogglePushSubscription event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentUser == null) return;

    if (!emit.isDone) {
      emit(ProfileUpdating(
        user: _currentUser!,
        message: 'Updating push subscription...',
      ));
    }

    try {
      final success = await _userService.subscribeToPush(
        event.userId,
        event.subscribe,
      );

      if (success) {
        // Profile will be updated via stream
      } else {
        if (!emit.isDone) {
          emit(const ProfileError('Failed to update push subscription'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateFavoriteGenres(
    UpdateFavoriteGenres event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentUser == null) return;

    if (!emit.isDone) {
      emit(ProfileUpdating(
        user: _currentUser!,
        message: 'Updating favorite genres...',
      ));
    }

    try {
      final success = await _userService.updateFavoriteGenres(
        event.userId,
        event.genres,
      );

      if (success) {
        // Profile will be updated via stream
      } else {
        if (!emit.isDone) {
          emit(const ProfileError('Failed to update favorite genres'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentUser != null && !isClosed && !emit.isDone) {
      emit(ProfileLoaded(
        user: _currentUser!,
        likedVideos: _likedVideos,
        savedVideos: _savedVideos,
      ));
    }
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    _likedVideosSubscription?.cancel();
    _savedVideosSubscription?.cancel();
    return super.close();
  }
}
