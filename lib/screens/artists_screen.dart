import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/artist/artist_bloc.dart';
import '../bloc/artist/artist_event.dart';
import '../bloc/artist/artist_state.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_view.dart';
import '../widgets/common/empty_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/artist.dart';
import 'artist_detail_screen.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({super.key});

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArtistBloc>().add(const LoadArtists());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      context.read<ArtistBloc>().add(const LoadArtists());
    } else {
      context.read<ArtistBloc>().add(SearchArtists(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'ARTISTS',
          style: AppTypography.h5.copyWith(
            letterSpacing: 3.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: AppSpacing.paddingAll,
            child: TextField(
              controller: _searchController,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'SEARCH ARTISTS...',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.textTertiary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          _performSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
                _performSearch(value);
              },
            ),
          ),

          // Artist List
          Expanded(
            child: BlocBuilder<ArtistBloc, ArtistState>(
              builder: (context, state) {
                if (state is ArtistLoading) {
                  return const LoadingIndicator(
                    message: 'Loading artists',
                  );
                }

                if (state is ArtistError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () {
                      context.read<ArtistBloc>().add(const LoadArtists());
                    },
                  );
                }

                if (state is ArtistsLoaded) {
                  if (state.artists.isEmpty) {
                    return EmptyState(
                      title: 'No Artists Found',
                      message: _searchController.text.isNotEmpty
                          ? 'Try searching for a different artist name'
                          : 'No artists available at the moment',
                      icon: Icons.person_outline,
                      actionText: _searchController.text.isNotEmpty
                          ? 'Clear Search'
                          : null,
                      onAction: _searchController.text.isNotEmpty
                          ? () {
                              _searchController.clear();
                              setState(() {});
                              _performSearch('');
                            }
                          : null,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ArtistBloc>().add(const LoadArtists());
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    color: AppColors.textPrimary,
                    backgroundColor: AppColors.surfaceVariant,
                    child: ListView.builder(
                      padding: AppSpacing.paddingAll,
                      itemCount: state.artists.length,
                      itemBuilder: (context, index) {
                        final artist = state.artists[index];
                        return _buildArtistCard(artist);
                      },
                    ),
                  );
                }

                return const LoadingIndicator();
              },
            ),
          ),
        ],
      ),
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
            // Artist Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.gray800,
                border: Border.all(color: AppColors.borderLight, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: artist.profileImageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.network(
                        artist.profileImageUrl,
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
                  if (artist.location.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          artist.location.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  if (artist.location.isNotEmpty)
                    const SizedBox(height: AppSpacing.xs),
                  if (artist.genres.isNotEmpty)
                    Text(
                      artist.genres.join(', ').toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}
