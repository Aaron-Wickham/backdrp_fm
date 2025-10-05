import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/cards/video_card_widget.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/app_user.dart';
import 'video_detail_screen.dart';
import 'edit_profile_screen.dart';
import 'settings/notification_settings_screen.dart';
import 'settings/privacy_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);

    // Load profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<ProfileBloc>().add(LoadProfile(authState.user.uid));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(
              child: LoadingIndicator(message: 'Loading profile'),
            ),
          );
        }

        final user = authState.user;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // Profile Header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.gray900,
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Profile Picture
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.gray800,
                              border: Border.all(
                                  color: AppColors.borderLight, width: 2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: user.profileImageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Image.network(
                                      user.profileImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
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
                          const SizedBox(height: AppSpacing.md),
                          // User Name
                          Text(
                            user.displayName.isNotEmpty
                                ? user.displayName.toUpperCase()
                                : 'USER',
                            style: AppTypography.h4.copyWith(
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          // Email
                          Text(
                            user.email,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Stats Bar
              SliverToBoxAdapter(
                child: Container(
                  padding: AppSpacing.paddingAll,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        Icons.favorite_border,
                        '${user.likedVideos.length}',
                        'LIKED',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.border,
                      ),
                      _buildStatItem(
                        Icons.bookmark_border,
                        '${user.savedVideos.length}',
                        'SAVED',
                      ),
                    ],
                  ),
                ),
              ),

              // Saved Videos Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Text(
                    'SAVED VIDEOS',
                    style: AppTypography.labelLarge.copyWith(
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),

              // Saved Videos Content
              SliverFillRemaining(
                child: _buildSavedVideosTab(user),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showSettingsSheet(context, user),
            backgroundColor: AppColors.surfaceVariant,
            label: Row(
              children: [
                const Icon(Icons.settings, color: AppColors.textPrimary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'SETTINGS',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSavedVideosTab(AppUser user) {
    // Load saved videos when tab is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<ProfileBloc>().add(LoadSavedVideos(user.uid));
      }
    });

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(
            child: LoadingIndicator(message: 'Loading saved videos'),
          );
        }

        if (state is ProfileLoaded) {
          if (state.savedVideos.isEmpty) {
            return EmptyState(
              title: 'No Saved Videos',
              message: 'Videos you save will appear here',
              icon: Icons.bookmark_border,
            );
          }

          return ListView.builder(
            padding: AppSpacing.paddingAll,
            itemCount: state.savedVideos.length,
            itemBuilder: (context, index) {
              final video = state.savedVideos[index];
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
          );
        }

        return EmptyState(
          title: 'No Saved Videos',
          message: 'Videos you save will appear here',
          icon: Icons.bookmark_border,
        );
      },
    );
  }


  void _showSettingsSheet(BuildContext context, AppUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      builder: (context) => Container(
        padding: AppSpacing.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SETTINGS',
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

            // Profile Settings
            _buildSettingItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: user),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),

            // Notifications
            _buildSettingItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),

            // Privacy
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacySettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Logout
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmation(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  border: Border.all(color: AppColors.borderLight, width: 1),
                  borderRadius: AppBorderRadius.radiusButton,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'LOGOUT',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              color: AppColors.textPrimary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        title: Text(
          'LOGOUT',
          style: AppTypography.h5.copyWith(
            letterSpacing: 2.0,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthLoggedOut());
            },
            child: Text(
              'LOGOUT',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
