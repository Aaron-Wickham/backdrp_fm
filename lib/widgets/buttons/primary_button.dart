import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool isInverted; // Black text on white bg

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.isInverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isInverted ? AppColors.primary : AppColors.secondary,
          foregroundColor: isInverted ? AppColors.textPrimary : AppColors.textInverse,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.disabledText,
          elevation: AppElevation.button,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.radiusButton,
            side: BorderSide(
              color: isInverted ? AppColors.borderLight : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isInverted ? AppColors.textPrimary : AppColors.textInverse,
                  ),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: AppSpacing.iconSizeSmall),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        text.toUpperCase(),
                        style: AppTypography.button,
                      ),
                    ],
                  )
                : Text(
                    text.toUpperCase(),
                    style: AppTypography.button,
                  ),
      ),
    );
  }
}
