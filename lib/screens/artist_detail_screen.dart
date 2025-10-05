import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/artist.dart';
import '../bloc/video/video_bloc.dart';
import '../bloc/video/video_event.dart';
import '../bloc/video/video_state.dart';
import '../widgets/cards/compact_video_card.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_view.dart';
import '../widgets/common/empty_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'video_detail_screen.dart';

class ArtistDetailScreen extends StatefulWidget {
  final Artist artist;

  const ArtistDetailScreen({
    super.key,
    required this.artist,
  });

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Add ability to sort videos by date, popularity, or duration
    // TODO: Show artist's upcoming events/tour dates if available
    // TODO: Add "Similar Artists" section based on genres
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoBloc>().add(LoadVideosByArtist(widget.artist.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Artist Banner
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray900,
                  border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: widget.artist.bannerImageUrl.isNotEmpty
                    ? Image.network(
                        widget.artist.bannerImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultBanner(),
                      )
                    : _buildDefaultBanner(),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Artist Header
                Container(
                  padding: AppSpacing.paddingAll,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Profile Image
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.gray800,
                          border: Border.all(color: AppColors.borderLight, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: widget.artist.profileImageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: Image.network(
                                  widget.artist.profileImageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.gray500,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.gray500,
                              ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Artist Name & Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.artist.name.toUpperCase(),
                              style: AppTypography.h3.copyWith(
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            if (widget.artist.location.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: AppColors.textTertiary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    widget.artist.location.toUpperCase(),
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                const Icon(
                                  Icons.video_library,
                                  size: 14,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  '${widget.artist.totalSets} VIDEOS',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Genres
                if (widget.artist.genres.isNotEmpty)
                  Container(
                    padding: AppSpacing.paddingAll,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GENRES',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: widget.artist.genres.map((genre) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.borderLight,
                                  width: 1,
                                ),
                                borderRadius: AppBorderRadius.radiusSM,
                              ),
                              child: Text(
                                genre.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                // Bio
                if (widget.artist.bio.isNotEmpty)
                  Container(
                    padding: AppSpacing.paddingAll,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BIO',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.artist.bio,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Social Links
                if (widget.artist.socialLinks.isNotEmpty)
                  Container(
                    padding: AppSpacing.paddingAll,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SOCIAL LINKS',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: widget.artist.socialLinks.entries.map((entry) {
                            return _buildSocialButton(entry.key, entry.value);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                // Videos Section Header
                Container(
                  padding: AppSpacing.paddingAll,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Text(
                    'VIDEOS',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),

                // Videos List
                BlocBuilder<VideoBloc, VideoState>(
                  builder: (context, state) {
                    if (state is VideoLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: LoadingIndicator(
                          message: 'Loading videos',
                        ),
                      );
                    }

                    if (state is VideoError) {
                      return Padding(
                        padding: AppSpacing.paddingAll,
                        child: ErrorView(
                          message: state.message,
                          onRetry: () {
                            context
                                .read<VideoBloc>()
                                .add(LoadVideosByArtist(widget.artist.id));
                          },
                        ),
                      );
                    }

                    if (state is VideoLoaded) {
                      if (state.videos.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: EmptyState(
                            title: 'No Videos Yet',
                            message: 'This artist hasn\'t posted any videos yet',
                            icon: Icons.video_library_outlined,
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.videos.length,
                        itemBuilder: (context, index) {
                          final video = state.videos[index];
                          return CompactVideoCard(
                            video: video,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoDetailScreen(video: video),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultBanner() {
    return Container(
      color: AppColors.gray900,
      child: Center(
        child: Icon(
          Icons.person,
          size: 80,
          color: AppColors.gray700,
        ),
      ),
    );
  }

  Widget _buildSocialButton(String platform, String url) {
    IconData icon;
    switch (platform.toLowerCase()) {
      case 'instagram':
        icon = Icons.camera_alt;
        break;
      case 'twitter':
      case 'x':
        icon = Icons.alternate_email;
        break;
      case 'facebook':
        icon = Icons.facebook;
        break;
      case 'youtube':
        icon = Icons.play_circle_outline;
        break;
      case 'spotify':
        icon = Icons.music_note;
        break;
      case 'soundcloud':
        icon = Icons.cloud;
        break;
      case 'website':
        icon = Icons.language;
        break;
      default:
        icon = Icons.link;
    }

    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        try {
          final canLaunch = await canLaunchUrl(uri);
          if (!mounted) return;

          if (canLaunch) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Could not open ${platform.toUpperCase()}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  backgroundColor: AppColors.surfaceVariant,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error opening link',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                backgroundColor: AppColors.surfaceVariant,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          border: Border.all(color: AppColors.borderLight, width: 1),
          borderRadius: AppBorderRadius.radiusSM,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              platform.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
