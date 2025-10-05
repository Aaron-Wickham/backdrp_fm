import 'package:backdrp_fm/bloc/navigation/navigation_event.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'services/service_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/archive_screen.dart';
import 'screens/artists_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/common/environment_banner.dart';
import 'bloc/bloc_observer.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/video/video_bloc.dart';
import 'bloc/artist/artist_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'bloc/navigation/navigation_bloc.dart';
import 'bloc/navigation/navigation_state.dart';
import 'theme/app_theme.dart';
import 'config/environment.dart';

// TODO: Add global error handler with FlutterError.onError and PlatformDispatcher.instance.onError
// TODO: Add crash reporting service (Firebase Crashlytics or Sentry)
// TODO: Add proper logging framework (logger package) instead of print statements
// TODO: Add app version checking and force update mechanism
// TODO: Add deep linking support for sharing specific videos/artists
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment from --dart-define flags or .env file
  await AppEnvironment.init();

  if (kDebugMode) {
    print('🚀 Starting BACKDRP.FM in ${AppEnvironment.name} mode');
  }

  // Initialize Firebase
  await Firebase.initializeApp(options: AppEnvironment.firebaseOptions);

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  // Set custom BLoC observer
  Bloc.observer = AppBlocObserver();

  // Initialize services
  final serviceProvider = ServiceProvider();
  await serviceProvider.initialize();

  runApp(MyApp(serviceProvider: serviceProvider));
}

class MyApp extends StatelessWidget {
  final ServiceProvider serviceProvider;

  const MyApp({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authService: serviceProvider.authService)
                ..add(const AuthStarted()),
        ),
        BlocProvider(
          create: (context) =>
              VideoBloc(videoService: serviceProvider.videoService),
        ),
        BlocProvider(
          create: (context) => ArtistBloc(
            artistService: serviceProvider.artistService,
            videoService: serviceProvider.videoService,
          ),
        ),
        BlocProvider(
          create: (context) =>
              ProfileBloc(userService: serviceProvider.userService),
        ),
        BlocProvider(create: (context) => NavigationBloc()),
      ],
      child: MaterialApp(
        title: 'BACKDRP.FM',
        theme: AppTheme.darkTheme,
        home: EnvironmentBanner(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading || state is AuthInitial) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is AuthAuthenticated) {
                return const MainScreen();
              }

              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              final navigationBloc = context.read<NavigationBloc>();
              switch (index) {
                case 0:
                  navigationBloc.add(const NavigateToHome());
                  break;
                case 1:
                  navigationBloc.add(const NavigateToArchive());
                  break;
                case 2:
                  navigationBloc.add(const NavigateToArtists());
                  break;
                case 3:
                  navigationBloc.add(const NavigateToProfile());
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive),
                label: 'Archive',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Artists',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(NavigationState state) {
    if (state is NavigationHome) {
      return const HomeScreen();
    } else if (state is NavigationArchive) {
      return const ArchiveScreen();
    } else if (state is NavigationArtists) {
      return const ArtistsScreen();
    } else if (state is NavigationProfile) {
      return const ProfileScreen();
    }
    return const HomeScreen();
  }
}


