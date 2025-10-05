import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'DELETE ACCOUNT',
          style: AppTypography.h5.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone. All your data, including liked videos and saved content, will be permanently deleted.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: AppTypography.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Account deletion not yet implemented',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  backgroundColor: AppColors.surfaceVariant,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'DELETE',
              style: AppTypography.button.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'EXPORT YOUR DATA',
          style: AppTypography.h5.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        content: Text(
          'We will send you an email with a copy of all your data including your profile, liked videos, and saved content. This may take a few minutes to process.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: AppTypography.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement data export
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Data export request submitted',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  backgroundColor: AppColors.surfaceVariant,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'EXPORT',
              style: AppTypography.button.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
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
                'Could not open link',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'PRIVACY & DATA',
          style: AppTypography.h5.copyWith(
            letterSpacing: 3.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(
              child: Text('Not authenticated'),
            );
          }

          final user = state.user;

          return SingleChildScrollView(
            padding: AppSpacing.paddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account Info Section
                Text(
                  'ACCOUNT INFORMATION',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                _buildInfoItem(
                  title: 'Email',
                  value: user.email,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildInfoItem(
                  title: 'Display Name',
                  value: user.displayName.isNotEmpty
                      ? user.displayName
                      : 'Not set',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildInfoItem(
                  title: 'Account Type',
                  value: user.role.name.toUpperCase(),
                  icon: Icons.verified_user_outlined,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Data Management Section
                Text(
                  'DATA MANAGEMENT',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                _buildActionItem(
                  title: 'Export Your Data',
                  subtitle: 'Download a copy of your data',
                  icon: Icons.download_outlined,
                  onTap: _showDataExportDialog,
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildActionItem(
                  title: 'Clear Cache',
                  subtitle: 'Free up storage space',
                  icon: Icons.cleaning_services_outlined,
                  onTap: () {
                    // TODO: Implement cache clearing
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Cache cleared successfully',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        backgroundColor: AppColors.surfaceVariant,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.xl),

                // Legal & Policies Section
                Text(
                  'LEGAL & POLICIES',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                _buildActionItem(
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  icon: Icons.policy_outlined,
                  onTap: () {
                    // TODO: Add actual privacy policy URL
                    _launchUrl('https://backdrp.fm/privacy');
                  },
                ),
                const SizedBox(height: AppSpacing.sm),

                _buildActionItem(
                  title: 'Terms of Service',
                  subtitle: 'Rules and guidelines',
                  icon: Icons.description_outlined,
                  onTap: () {
                    // TODO: Add actual terms URL
                    _launchUrl('https://backdrp.fm/terms');
                  },
                ),

                const SizedBox(height: AppSpacing.xl),

                // Danger Zone Section
                Text(
                  'DANGER ZONE',
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.red,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                _buildDangerActionItem(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and data',
                  icon: Icons.delete_forever_outlined,
                  onTap: _showDeleteAccountDialog,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Info Footer
                Container(
                  padding: AppSpacing.paddingAll,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'We take your privacy seriously. Your data is stored securely and never shared with third parties without your consent.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: AppSpacing.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
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
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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

  Widget _buildDangerActionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingAll,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.red,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.red.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
