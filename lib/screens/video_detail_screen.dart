import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/video.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/video/video_bloc.dart';
import '../bloc/video/video_event.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

class VideoDetailScreen extends StatefulWidget {
  final Video video;

  const VideoDetailScreen({
    super.key,
    required this.video,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
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

    // Check if user has liked or saved this video
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
      // TODO: Add optimistic update with rollback on error
      // TODO: Add haptic feedback on like/unlike
      context.read<VideoBloc>().add(
            LikeVideo(
              videoId: widget.video.id,
              userId: authState.user.uid,
            ),
          );
      setState(() => _isLiked = !_isLiked);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLiked ? 'Added to liked videos' : 'Removed from liked videos'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      // TODO: Show login prompt dialog instead of silent fail
    }
  }

  void _toggleSave() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      // TODO: Add optimistic update with rollback on error
      context.read<VideoBloc>().add(
            SaveVideo(
              videoId: widget.video.id,
              userId: authState.user.uid,
            ),
          );
      setState(() => _isSaved = !_isSaved);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isSaved ? 'Added to saved videos' : 'Removed from saved videos'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      // TODO: Show login prompt dialog instead of silent fail
    }
  }

  void _shareVideo() {
    final youtubeUrl = 'https://www.youtube.com/watch?v=${widget.video.youtubeId}';
    final shareText = '''
🎵 ${widget.video.title}
🎤 ${widget.video.artist}
📍 ${widget.video.location.venue}, ${widget.video.location.city}

Watch on BACKDRP.FM: $youtubeUrl
''';

    Share.share(
      shareText,
      subject: '${widget.video.title} by ${widget.video.artist}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Video Player
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: AppColors.secondary,
                  progressColors: const ProgressBarColors(
                    playedColor: AppColors.secondary,
                    handleColor: AppColors.secondary,
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Artist Section
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
                        widget.video.title.toUpperCase(),
                        style: AppTypography.h3.copyWith(
                          letterSpacing: 1.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.video.artist.toUpperCase(),
                        style: AppTypography.h5.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats Bar
                // TODO: Add real-time view counter that increments when user watches
                // TODO: Track watch time analytics (how long users actually watch)
                Container(
                  padding: AppSpacing.paddingAll,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        Icons.favorite_border,
                        _formatNumber(widget.video.likes),
                        'LIKES',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.border,
                      ),
                      _buildStatItem(
                        Icons.remove_red_eye_outlined,
                        _formatNumber(widget.video.views),
                        'VIEWS',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.border,
                      ),
                      _buildStatItem(
                        Icons.access_time,
                        _formatDuration(widget.video.duration),
                        'DURATION',
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: AppSpacing.paddingAll,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                          label: 'LIKE',
                          onTap: _toggleLike,
                          isActive: _isLiked,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildActionButton(
                          icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                          label: 'SAVE',
                          onTap: _toggleSave,
                          isActive: _isSaved,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.share_outlined,
                          label: 'SHARE',
                          onTap: _shareVideo,
                        ),
                      ),
                    ],
                  ),
                ),

                // Details Section
                Padding(
                  padding: AppSpacing.paddingAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Card
                      _buildInfoCard(
                        title: 'LOCATION',
                        children: [
                          _buildInfoRow(
                            Icons.location_city,
                            'VENUE',
                            widget.video.location.venue,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            'CITY',
                            widget.video.location.city,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          _buildInfoRow(
                            Icons.public,
                            'COUNTRY',
                            widget.video.location.country,
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Details Card
                      _buildInfoCard(
                        title: 'DETAILS',
                        children: [
                          if (widget.video.recordedDate != null)
                            _buildInfoRow(
                              Icons.event,
                              'RECORDED',
                              _formatDate(widget.video.recordedDate!),
                            ),
                          if (widget.video.recordedDate != null)
                            const SizedBox(height: AppSpacing.sm),
                          if (widget.video.publishedDate != null)
                            _buildInfoRow(
                              Icons.publish,
                              'PUBLISHED',
                              _formatDate(widget.video.publishedDate!),
                            ),
                          if (widget.video.publishedDate != null)
                            const SizedBox(height: AppSpacing.sm),
                          if (widget.video.genres.isNotEmpty)
                            _buildGenreRow(),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Description Card
                      if (widget.video.description.isNotEmpty)
                        _buildInfoCard(
                          title: 'DESCRIPTION',
                          children: [
                            Text(
                              widget.video.description,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: AppSpacing.md),

                      // Tags
                      if (widget.video.tags.isNotEmpty)
                        _buildInfoCard(
                          title: 'TAGS',
                          children: [
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: widget.video.tags.map((tag) {
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
                                    '#${tag.toUpperCase()}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h5.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondary : AppColors.surfaceVariant,
          border: Border.all(
            color: isActive ? AppColors.secondary : AppColors.borderLight,
            width: 1,
          ),
          borderRadius: AppBorderRadius.radiusButton,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.textInverse : AppColors.textPrimary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: AppBorderRadius.radiusCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '$label: ',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        Expanded(
          child: Text(
            value.toUpperCase(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.music_note,
          size: 16,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'GENRES: ',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: widget.video.genres.map((genre) {
              return Text(
                genre.toUpperCase(),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    final months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
