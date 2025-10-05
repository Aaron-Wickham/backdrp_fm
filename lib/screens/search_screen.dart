import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video/video_bloc.dart';
import '../bloc/video/video_event.dart';
import '../bloc/video/video_state.dart';
import '../bloc/artist/artist_bloc.dart';
import '../bloc/artist/artist_event.dart';
import '../bloc/artist/artist_state.dart';
import '../widgets/cards/compact_video_card.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/empty_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/artist.dart';
import 'video_detail_screen.dart';
import 'artist_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _isSearching = false);
      return;
    }

    setState(() => _isSearching = true);

    // Search in current tab
    if (_tabController.index == 0) {
      // Videos tab
      context.read<VideoBloc>().add(SearchVideos(query));
    } else {
      // Artists tab
      context.read<ArtistBloc>().add(SearchArtists(query));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _isSearching = false);
    context.read<VideoBloc>().add(const LoadVideos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'SEARCH...',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {});
            _performSearch(value);
          },
        ),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              },
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textTertiary,
              labelStyle: AppTypography.labelLarge,
              indicatorColor: AppColors.textPrimary,
              indicatorWeight: 2,
              tabs: const [
                Tab(text: 'VIDEOS'),
                Tab(text: 'ARTISTS'),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Videos Tab
                _buildVideosTab(),

                // Artists Tab
                _buildArtistsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosTab() {
    if (!_isSearching) {
      return _buildSearchSuggestions();
    }

    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return const LoadingIndicator(message: 'Searching videos');
        }

        if (state is VideoLoaded) {
          if (state.videos.isEmpty) {
            return EmptyState(
              title: 'No Videos Found',
              message: 'Try searching for a different title, artist, or tag',
              icon: Icons.video_library_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            itemCount: state.videos.length,
            itemBuilder: (context, index) {
              final video = state.videos[index];
              return CompactVideoCard(
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
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildArtistsTab() {
    if (!_isSearching) {
      return _buildSearchSuggestions();
    }

    return BlocBuilder<ArtistBloc, ArtistState>(
      builder: (context, state) {
        if (state is ArtistLoading) {
          return const LoadingIndicator(message: 'Searching artists');
        }

        if (state is ArtistsLoaded) {
          if (state.artists.isEmpty) {
            return EmptyState(
              title: 'No Artists Found',
              message: 'Try searching for a different artist name',
              icon: Icons.person_outline,
            );
          }

          return ListView.builder(
            padding: AppSpacing.paddingAll,
            itemCount: state.artists.length,
            itemBuilder: (context, index) {
              final artist = state.artists[index];
              return _buildArtistCard(artist);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildArtistCard(Artist artist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailScreen(artist: artist),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: AppSpacing.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          border: Border.all(color: AppColors.border, width: 1),
          borderRadius: AppBorderRadius.radiusCard,
        ),
        child: Row(
        children: [
          // Artist Image Placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.gray800,
              border: Border.all(color: AppColors.borderLight, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.person,
              size: 32,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Artist Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.name.toUpperCase(),
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (artist.genres.isNotEmpty)
                  Text(
                    artist.genres.join(', ').toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.video_library,
                      size: 12,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${artist.totalSets} VIDEOS',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textTertiary,
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: AppSpacing.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),

          // Search Tips
          Text(
            'SEARCH TIPS',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          _buildTipCard(
            icon: Icons.video_library_outlined,
            title: 'Videos',
            description: 'Search by title, artist name, description, or tags',
          ),
          const SizedBox(height: AppSpacing.sm),

          _buildTipCard(
            icon: Icons.person_outline,
            title: 'Artists',
            description: 'Find your favorite artists and explore their videos',
          ),
          const SizedBox(height: AppSpacing.xl),

          // Popular Searches
          Text(
            'POPULAR SEARCHES',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildSuggestionChip('Live'),
              _buildSuggestionChip('Jazz'),
              _buildSuggestionChip('Electronic'),
              _buildSuggestionChip('New York'),
              _buildSuggestionChip('Berlin'),
              _buildSuggestionChip('Festival'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Genres
          Text(
            'BROWSE BY GENRE',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildGenreChip('Pop'),
              _buildGenreChip('R&B'),
              _buildGenreChip('Electronic'),
              _buildGenreChip('House'),
              _buildGenreChip('Indie'),
              _buildGenreChip('Jazz'),
              _buildGenreChip('Soul'),
              _buildGenreChip('Hip Hop'),
              _buildGenreChip('Rap'),
              _buildGenreChip('Rock'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: AppSpacing.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: AppBorderRadius.radiusCard,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        _performSearch(label);
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
            const Icon(
              Icons.search,
              size: 14,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label.toUpperCase(),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreChip(String genre) {
    return GestureDetector(
      onTap: () {
        _searchController.text = genre;
        _performSearch(genre);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight, width: 1),
          borderRadius: AppBorderRadius.radiusSM,
        ),
        child: Text(
          genre.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
