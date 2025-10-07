import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:backdrp_fm/bloc/auth/auth_bloc.dart';
import 'package:backdrp_fm/bloc/auth/auth_state.dart';
import 'package:backdrp_fm/bloc/auth/auth_event.dart';
import 'package:backdrp_fm/bloc/video/video_bloc.dart';
import 'package:backdrp_fm/bloc/video/video_state.dart';
import 'package:backdrp_fm/bloc/video/video_event.dart';
import 'package:backdrp_fm/models/video.dart';
import 'package:backdrp_fm/models/app_user.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockVideoBloc extends MockBloc<VideoEvent, VideoState>
    implements VideoBloc {}

// Testable VideoDetailScreen that accepts a custom player builder
class TestableVideoDetailScreen extends StatefulWidget {
  final Video video;
  final Widget Function(YoutubePlayerController)? playerBuilder;

  const TestableVideoDetailScreen({
    super.key,
    required this.video,
    this.playerBuilder,
  });

  @override
  State<TestableVideoDetailScreen> createState() =>
      _TestableVideoDetailScreenState();
}

class _TestableVideoDetailScreenState extends State<TestableVideoDetailScreen> {
  late YoutubePlayerController _controller;
  bool _isLiked = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        setState(() {
          _isLiked = authState.user.likedVideos.contains(widget.video.id);
          _isSaved = authState.user.savedVideos.contains(widget.video.id);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<VideoBloc>().add(
            LikeVideo(
              videoId: widget.video.id,
              userId: authState.user.uid,
            ),
          );
      setState(() => _isLiked = !_isLiked);
    }
  }

  void _toggleSave() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<VideoBloc>().add(
            SaveVideo(
              videoId: widget.video.id,
              userId: authState.user.uid,
            ),
          );
      setState(() => _isSaved = !_isSaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Use custom player builder if provided, otherwise use mock
          widget.playerBuilder?.call(_controller) ??
              Container(
                height: 200,
                color: Colors.black87,
                child: const Center(
                  child: Icon(Icons.play_circle_outline,
                      size: 64, color: Colors.white),
                ),
              ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.video.artist.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                              ),
                              onPressed: _toggleLike,
                            ),
                            IconButton(
                              icon: Icon(
                                _isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: Colors.white,
                              ),
                              onPressed: _toggleSave,
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.share, color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.video.description,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.video.location.venue.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${widget.video.location.city.toUpperCase()}, ${widget.video.location.country.toUpperCase()}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: widget.video.genres
                              .map((genre) => Chip(
                                    label: Text(genre.toUpperCase()),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: widget.video.tags
                              .map((tag) => Chip(
                                    label: Text(tag.toUpperCase()),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${widget.video.views} VIEWS',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${widget.video.likes} LIKES',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${widget.video.duration ~/ 60}:${(widget.video.duration % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockVideoBloc mockVideoBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockVideoBloc = MockVideoBloc();
  });

  setUpAll(() {
    registerFallbackValue(const LoadVideos());
    registerFallbackValue(const LikeVideo(videoId: '', userId: ''));
    registerFallbackValue(const SaveVideo(videoId: '', userId: ''));
  });

  final testVideo = Video(
    id: 'video1',
    youtubeUrl: 'https://youtube.com/watch?v=test123',
    youtubeId: 'test123',
    thumbnailUrl: 'https://img.youtube.com/vi/test123/maxresdefault.jpg',
    title: 'Test Video',
    artist: 'Test Artist',
    artistId: 'artist1',
    description: 'This is a test video description',
    genres: ['Electronic', 'House'],
    location: VideoLocation(
      venue: 'Test Venue',
      city: 'Los Angeles',
      country: 'USA',
    ),
    duration: 180,
    status: 'published',
    likes: 10,
    views: 100,
    featured: true,
    sortOrder: 1,
    tags: ['live', 'concert'],
  );

  final testUser = AppUser(
    uid: 'user1',
    email: 'test@example.com',
    displayName: 'Test User',
    role: UserRole.user,
    likedVideos: const [],
    savedVideos: const [],
    emailSubscribed: true,
    pushSubscribed: true,
    preferences: UserPreferences(
      favoriteGenres: const [],
    ),
  );

  Widget createTestableVideoDetailScreen() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          BlocProvider<VideoBloc>.value(value: mockVideoBloc),
        ],
        child: TestableVideoDetailScreen(video: testVideo),
      ),
    );
  }

  group('VideoDetailScreen with Mock Player', () {
    testWidgets('displays video title', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();

      expect(find.text('TEST VIDEO'), findsOneWidget);
    });

    testWidgets('displays artist name', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();

      expect(find.text('TEST ARTIST'), findsOneWidget);
    });

    testWidgets('displays video description', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();

      expect(find.text('This is a test video description'), findsOneWidget);
    });

    testWidgets('displays video location', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();

      expect(find.text('TEST VENUE'), findsOneWidget);
      expect(find.text('LOS ANGELES, USA'), findsOneWidget);
    });

    testWidgets('displays like and save buttons', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('shows liked state when user has liked video', (tester) async {
      final userWithLike = AppUser(
        uid: testUser.uid,
        email: testUser.email,
        displayName: testUser.displayName,
        role: testUser.role,
        likedVideos: const ['video1'],
        savedVideos: testUser.savedVideos,
        emailSubscribed: testUser.emailSubscribed,
        pushSubscribed: testUser.pushSubscribed,
        preferences: testUser.preferences,
      );
      when(() => mockAuthBloc.state)
          .thenReturn(AuthAuthenticated(userWithLike));
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('like button dispatches LikeVideo when authenticated',
        (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthAuthenticated(testUser));
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      verify(() => mockVideoBloc
          .add(const LikeVideo(videoId: 'video1', userId: 'user1'))).called(1);
    });

    testWidgets('displays views and likes count', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();

      expect(find.text('100 VIEWS'), findsOneWidget);
      expect(find.text('10 LIKES'), findsOneWidget);
    });

    testWidgets('displays video duration', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();

      expect(find.text('3:00'), findsOneWidget);
    });

    testWidgets('displays back button', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(const AuthUnauthenticated());
      when(() => mockVideoBloc.state).thenReturn(const VideoInitial());

      await tester.pumpWidget(createTestableVideoDetailScreen());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
