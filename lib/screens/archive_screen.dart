import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/video/video_bloc.dart';
import '../bloc/video/video_event.dart';
import '../bloc/video/video_state.dart';
import '../widgets/cards/compact_video_card.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_view.dart';
import '../widgets/common/empty_state.dart';
import '../theme/app_typography.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'video_detail_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedGenre;
  String? _selectedArtist;
  String? _selectedArtistName; // Store artist name for display
  String? _selectedCity;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoBloc>().add(const LoadVideos());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final List<String>? genres = _selectedGenre != null ? [_selectedGenre!] : null;

    context.read<VideoBloc>().add(
          FilterVideos(
            genres: genres,
            artistId: _selectedArtist,
            city: _selectedCity,
            country: _selectedCountry,
          ),
        );
  }

  void _clearFilters() {
    setState(() {
      _selectedGenre = null;
      _selectedArtist = null;
      _selectedArtistName = null;
      _selectedCity = null;
      _selectedCountry = null;
      _searchController.clear();
    });
    context.read<VideoBloc>().add(const LoadVideos());
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      builder: (context) => _buildFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ARCHIVE',
          style: AppTypography.h5.copyWith(
            letterSpacing: 3.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
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
                hintText: 'SEARCH VIDEOS...',
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
                          context.read<VideoBloc>().add(const SearchVideos(''));
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
                if (value.isEmpty) {
                  context.read<VideoBloc>().add(const LoadVideos());
                } else {
                  context.read<VideoBloc>().add(SearchVideos(value));
                }
              },
            ),
          ),

          // Active Filters
          if (_selectedGenre != null ||
              _selectedArtist != null ||
              _selectedArtistName != null ||
              _selectedCity != null ||
              _selectedCountry != null)
            _buildActiveFilters(),

          // Video List
          Expanded(
            child: BlocBuilder<VideoBloc, VideoState>(
              builder: (context, state) {
                if (state is VideoLoading) {
                  return const LoadingIndicator(
                    message: 'Loading archive',
                  );
                }

                if (state is VideoError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () {
                      context.read<VideoBloc>().add(const LoadVideos());
                    },
                  );
                }

                if (state is VideoLoaded) {
                  if (state.videos.isEmpty) {
                    return EmptyState(
                      title: 'No Videos Found',
                      message: 'Try adjusting your filters or search query',
                      icon: Icons.video_library_outlined,
                      actionText: 'Clear Filters',
                      onAction: _clearFilters,
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
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
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

  Widget _buildActiveFilters() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          if (_selectedGenre != null)
            _buildFilterChip(
              label: _selectedGenre!,
              onRemove: () {
                setState(() => _selectedGenre = null);
                _applyFilters();
              },
            ),
          if (_selectedArtistName != null)
            _buildFilterChip(
              label: _selectedArtistName!,
              onRemove: () {
                setState(() {
                  _selectedArtist = null;
                  _selectedArtistName = null;
                });
                _applyFilters();
              },
            ),
          if (_selectedCity != null)
            _buildFilterChip(
              label: _selectedCity!,
              onRemove: () {
                setState(() => _selectedCity = null);
                _applyFilters();
              },
            ),
          if (_selectedCountry != null)
            _buildFilterChip(
              label: _selectedCountry!,
              onRemove: () {
                setState(() => _selectedCountry = null);
                _applyFilters();
              },
            ),
          // Clear All button
          GestureDetector(
            onTap: _clearFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight, width: 1),
                borderRadius: AppBorderRadius.radiusSM,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.clear_all,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'CLEAR ALL',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.borderLight, width: 1),
        borderRadius: AppBorderRadius.radiusSM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: AppSpacing.paddingAll,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FILTERS',
                    style: AppTypography.h5.copyWith(
                      letterSpacing: 2.0,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Genre Filter
              Text(
                'GENRE',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _buildGenreChips(setModalState),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Artist Filter
              Text(
                'ARTIST',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _buildArtistChips(setModalState),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Location Filter
              Text(
                'LOCATION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _buildLocationChips(setModalState),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedGenre = null;
                          _selectedArtist = null;
                          _selectedArtistName = null;
                          _selectedCity = null;
                          _selectedCountry = null;
                        });
                      },
                      child: Text(
                        'CLEAR',
                        style: AppTypography.button,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'APPLY',
                        style: AppTypography.button,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildGenreChips(StateSetter setModalState) {
    final genres = [
      'Pop',
      'R&B',
      'Electronic',
      'House',
      'Indie',
      'Jazz',
      'Soul',
      'Hip Hop',
      'Rap',
      'Rock',
    ];

    return genres.map((genre) {
      final isSelected = _selectedGenre == genre;
      return GestureDetector(
        onTap: () {
          setModalState(() {
            _selectedGenre = isSelected ? null : genre;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : AppColors.surfaceVariant,
            border: Border.all(
              color: isSelected ? AppColors.secondary : AppColors.borderLight,
              width: 1,
            ),
            borderRadius: AppBorderRadius.radiusSM,
          ),
          child: Text(
            genre.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildArtistChips(StateSetter setModalState) {
    final artists = [
      {'id': 'dev_artist_001', 'name': 'The Weeknd'},
      {'id': 'dev_artist_002', 'name': 'Daft Punk'},
      {'id': 'dev_artist_003', 'name': 'Billie Eilish'},
      {'id': 'dev_artist_004', 'name': 'Robert Glasper'},
      {'id': 'dev_artist_005', 'name': 'Travis Scott'},
    ];

    return artists.map((artist) {
      final artistId = artist['id']!;
      final artistName = artist['name']!;
      final isSelected = _selectedArtist == artistId;

      return GestureDetector(
        onTap: () {
          setModalState(() {
            if (isSelected) {
              _selectedArtist = null;
              _selectedArtistName = null;
            } else {
              _selectedArtist = artistId;
              _selectedArtistName = artistName;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : AppColors.surfaceVariant,
            border: Border.all(
              color: isSelected ? AppColors.secondary : AppColors.borderLight,
              width: 1,
            ),
            borderRadius: AppBorderRadius.radiusSM,
          ),
          child: Text(
            artistName.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildLocationChips(StateSetter setModalState) {
    final locations = [
      {'city': 'New York', 'country': 'USA'},
      {'city': 'Los Angeles', 'country': 'USA'},
      {'city': 'Berlin', 'country': 'Germany'},
      {'city': 'Tokyo', 'country': 'Japan'},
      {'city': 'London', 'country': 'UK'},
      {'city': 'Paris', 'country': 'France'},
    ];

    return locations.map((location) {
      final city = location['city']!;
      final country = location['country']!;
      final isSelected = _selectedCity == city;

      return GestureDetector(
        onTap: () {
          setModalState(() {
            if (isSelected) {
              _selectedCity = null;
              _selectedCountry = null;
            } else {
              _selectedCity = city;
              _selectedCountry = country;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : AppColors.surfaceVariant,
            border: Border.all(
              color: isSelected ? AppColors.secondary : AppColors.borderLight,
              width: 1,
            ),
            borderRadius: AppBorderRadius.radiusSM,
          ),
          child: Text(
            '$city, $country'.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? AppColors.textInverse : AppColors.textPrimary,
            ),
          ),
        ),
      );
    }).toList();
  }
}
