import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video/video_bloc.dart';
import '../bloc/video/video_event.dart';
import '../bloc/video/video_state.dart';
import '../widgets/cards/video_card_widget.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_view.dart';
import '../widgets/common/empty_state.dart';
import '../theme/app_typography.dart';
import '../theme/app_colors.dart';
import 'video_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Add infinite scroll pagination instead of loading all at once
    // TODO: Add filter chips for quick genre filtering on home screen
    // TODO: Add "Trending This Week" section with different sorting
    // Load featured videos after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoBloc>().add(const LoadFeaturedVideos(limit: 20));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BACKDRP.FM',
          style: AppTypography.h5.copyWith(
            letterSpacing: 3.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoLoading) {
            return const LoadingIndicator(
              message: 'Loading videos',
            );
          }

          if (state is VideoError) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context
                    .read<VideoBloc>()
                    .add(const LoadFeaturedVideos(limit: 20));
              },
            );
          }

          if (state is VideoLoaded) {
            if (state.videos.isEmpty) {
              return EmptyState(
                title: 'No Videos',
                message: 'No videos available at the moment',
                icon: Icons.video_library_outlined,
                actionText: 'Refresh',
                onAction: () {
                  context
                      .read<VideoBloc>()
                      .add(const LoadFeaturedVideos(limit: 20));
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<VideoBloc>().add(const LoadVideos());
                await Future.delayed(const Duration(seconds: 1));
              },
              color: AppColors.textPrimary,
              backgroundColor: AppColors.surfaceVariant,
              child: ListView.builder(
                itemCount: state.videos.length,
                itemBuilder: (context, index) {
                  final video = state.videos[index];
                  return VideoCardWidget(
                    video: video,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoDetailScreen(video: video),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          // Initial state
          return const LoadingIndicator();
        },
      ),
    );
  }
}

