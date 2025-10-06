import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  late bool _newSets;
  late bool _artistUpdates;
  late bool _weeklyDigest;
  late bool _emailSubscribed;
  late bool _pushSubscribed;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      _newSets = user.preferences.notificationPreferences.newSets;
      _artistUpdates = user.preferences.notificationPreferences.artistUpdates;
      _weeklyDigest = user.preferences.notificationPreferences.weeklyDigest;
      _emailSubscribed = user.emailSubscribed;
      _pushSubscribed = user.pushSubscribed;
    } else {
      _newSets = true;
      _artistUpdates = true;
      _weeklyDigest = true;
      _emailSubscribed = true;
      _pushSubscribed = true;
    }
  }

  void _saveSettings() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<ProfileBloc>().add(
            UpdateNotificationSettings(
              userId: authState.user.uid,
              newSets: _newSets,
              artistUpdates: _artistUpdates,
              weeklyDigest: _weeklyDigest,
              emailSubscribed: _emailSubscribed,
              pushSubscribed: _pushSubscribed,
            ),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'NOTIFICATION SETTINGS UPDATED',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: AppColors.surfaceVariant,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'NOTIFICATIONS',
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
      body: SingleChildScrollView(
        padding: AppSpacing.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Notifications Section
            Text(
              'EMAIL NOTIFICATIONS',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            _buildSwitchItem(
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              value: _emailSubscribed,
              onChanged: (value) {
                setState(() => _emailSubscribed = value);
              },
            ),
            const SizedBox(height: AppSpacing.sm),

            if (_emailSubscribed) ...[
              _buildSwitchItem(
                title: 'New Sets',
                subtitle: 'Get notified when new videos are published',
                value: _newSets,
                onChanged: (value) {
                  setState(() => _newSets = value);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildSwitchItem(
                title: 'Artist Updates',
                subtitle: 'Updates from artists you like',
                value: _artistUpdates,
                onChanged: (value) {
                  setState(() => _artistUpdates = value);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildSwitchItem(
                title: 'Weekly Digest',
                subtitle: 'Weekly summary of top content',
                value: _weeklyDigest,
                onChanged: (value) {
                  setState(() => _weeklyDigest = value);
                },
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Push Notifications Section
            Text(
              'PUSH NOTIFICATIONS',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            _buildSwitchItem(
              title: 'Push Notifications',
              subtitle: 'Receive push notifications on your device',
              value: _pushSubscribed,
              onChanged: (value) {
                setState(() => _pushSubscribed = value);
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // Info Text
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
                      'You can always change these settings later. Unsubscribing from all notifications may cause you to miss important updates.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(
                    'SAVE SETTINGS',
                    style: AppTypography.button,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: AppSpacing.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
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
          const SizedBox(width: AppSpacing.md),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.secondary,
            activeTrackColor: AppColors.gray700,
            inactiveThumbColor: AppColors.gray500,
            inactiveTrackColor: AppColors.gray800,
          ),
        ],
      ),
    );
  }
}
