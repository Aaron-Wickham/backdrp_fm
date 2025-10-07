import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textInverse,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
        outline: AppColors.border,
        surfaceContainerHighest: AppColors.surfaceVariant,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: AppElevation.appBar,
        centerTitle: false,
        titleTextStyle: AppTypography.h5.copyWith(
          color: AppColors.textPrimary,
          letterSpacing: 2.0, // Wide tracking for tech feel
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSpacing.iconSize,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge:
            AppTypography.display1.copyWith(color: AppColors.textPrimary),
        displayMedium:
            AppTypography.display2.copyWith(color: AppColors.textPrimary),
        displaySmall:
            AppTypography.display3.copyWith(color: AppColors.textPrimary),
        headlineLarge: AppTypography.h1.copyWith(color: AppColors.textPrimary),
        headlineMedium: AppTypography.h2.copyWith(color: AppColors.textPrimary),
        headlineSmall: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        titleLarge: AppTypography.h4.copyWith(color: AppColors.textPrimary),
        titleMedium: AppTypography.h5.copyWith(color: AppColors.textPrimary),
        titleSmall: AppTypography.h6.copyWith(color: AppColors.textPrimary),
        bodyLarge:
            AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
        bodyMedium:
            AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
        bodySmall:
            AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        labelLarge:
            AppTypography.labelLarge.copyWith(color: AppColors.textPrimary),
        labelMedium:
            AppTypography.labelMedium.copyWith(color: AppColors.textPrimary),
        labelSmall:
            AppTypography.labelSmall.copyWith(color: AppColors.textSecondary),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceVariant,
        elevation: AppElevation.card,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.radiusCard,
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        margin: AppSpacing.marginAll,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.textInverse,
          elevation: AppElevation.button,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.radiusButton,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSizes.buttonHeight),
          textStyle: AppTypography.button,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.radiusButton,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(0, AppSizes.buttonHeight),
          textStyle: AppTypography.button,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          minimumSize: const Size(0, AppSizes.buttonHeight),
          textStyle: AppTypography.button,
        ),
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          iconSize: AppSpacing.iconSize,
          padding: const EdgeInsets.all(AppSpacing.sm),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: AppSpacing.paddingAll,
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusInput,
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusInput,
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusInput,
          borderSide: const BorderSide(
            color: AppColors.textPrimary,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusInput,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.radiusInput,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        errorStyle: AppTypography.caption.copyWith(
          color: AppColors.error,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textTertiary,
        elevation: AppElevation.none,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTypography.labelSmall,
        unselectedLabelStyle: AppTypography.labelSmall,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppElevation.dialog,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.radiusDialog,
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        titleTextStyle: AppTypography.h5.copyWith(
          color: AppColors.textPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        deleteIconColor: AppColors.textSecondary,
        disabledColor: AppColors.disabled,
        selectedColor: AppColors.secondary,
        secondarySelectedColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        labelStyle: AppTypography.labelSmall,
        secondaryLabelStyle: AppTypography.labelSmall,
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.radiusSM,
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.gray800,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.radiusSM,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppElevation.md,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.textPrimary,
        linearTrackColor: AppColors.gray700,
        circularTrackColor: AppColors.gray700,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary;
          }
          return AppColors.gray500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.gray500;
          }
          return AppColors.gray700;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.primary),
        side: const BorderSide(
          color: AppColors.border,
          width: 1,
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary;
          }
          return AppColors.border;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.secondary,
        inactiveTrackColor: AppColors.gray700,
        thumbColor: AppColors.secondary,
        overlayColor: AppColors.overlayLight,
        valueIndicatorColor: AppColors.secondary,
        valueIndicatorTextStyle: AppTypography.caption.copyWith(
          color: AppColors.textInverse,
        ),
      ),
    );
  }
}
