import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'video_service.dart';
import 'artist_service.dart';
import 'user_service.dart';
import 'playlist_service.dart';

class ServiceProvider extends ChangeNotifier {
  // Singleton instance
  static final ServiceProvider _instance = ServiceProvider._internal();

  factory ServiceProvider() {
    return _instance;
  }

  ServiceProvider._internal();

  // Service instances
  late final AuthService _authService;
  late final VideoService _videoService;
  late final ArtistService _artistService;
  late final UserService _userService;
  late final PlaylistService _playlistService;

  bool _initialized = false;

  // Getters for services
  AuthService get authService => _authService;
  VideoService get videoService => _videoService;
  ArtistService get artistService => _artistService;
  UserService get userService => _userService;
  PlaylistService get playlistService => _playlistService;

  bool get initialized => _initialized;

  // Initialize all services
  Future<void> initialize() async {
    if (_initialized) return;

    _authService = AuthService();
    _videoService = VideoService();
    _artistService = ArtistService();
    _userService = UserService();
    _playlistService = PlaylistService();

    _initialized = true;
    notifyListeners();
  }

  // Static convenience getters
  static AuthService get auth => _instance._authService;
  static VideoService get video => _instance._videoService;
  static ArtistService get artist => _instance._artistService;
  static UserService get user => _instance._userService;
  static PlaylistService get playlist => _instance._playlistService;
}
