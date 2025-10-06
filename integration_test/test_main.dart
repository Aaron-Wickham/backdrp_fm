import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:backdrp_fm/firebase_options_dev.dart';
import 'package:backdrp_fm/test_helpers/emulator_config.dart';
import 'package:backdrp_fm/blocs/auth/auth_bloc.dart';
import 'package:backdrp_fm/blocs/videos/videos_bloc.dart';
import 'package:backdrp_fm/blocs/artists/artists_bloc.dart';
import 'package:backdrp_fm/blocs/profile/profile_bloc.dart';
import 'package:backdrp_fm/services/auth_service.dart';
import 'package:backdrp_fm/services/video_service.dart';
import 'package:backdrp_fm/services/artist_service.dart';
import 'package:backdrp_fm/services/user_service.dart';
import 'package:backdrp_fm/app.dart';

/// Test entry point that connects to Firebase Emulators
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with dev configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connect to Firebase Emulators
  useFirebaseEmulators();

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  // Initialize services
  final authService = AuthService();
  final videoService = VideoService();
  final artistService = ArtistService();
  final userService = UserService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: authService)
            ..add(AuthCheckRequested()),
        ),
        BlocProvider<VideosBloc>(
          create: (context) => VideosBloc(videoService: videoService)
            ..add(LoadVideos()),
        ),
        BlocProvider<ArtistsBloc>(
          create: (context) => ArtistsBloc(artistService: artistService)
            ..add(LoadArtists()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(userService: userService),
        ),
      ],
      child: const App(),
    ),
  );
}
