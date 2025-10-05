import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../config/environment.dart';
import '../../theme/app_typography.dart';

/// Shows a banner at the top of the screen in debug builds
/// to indicate the current environment (DEV, STAGING, PROD)
class EnvironmentBanner extends StatelessWidget {
  final Widget child;

  const EnvironmentBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode and non-production environments
    if (!kDebugMode || AppEnvironment.isProduction) {
      return child;
    }

    return Banner(
      message: AppEnvironment.name,
      location: BannerLocation.topEnd,
      color: _getBannerColor(),
      textStyle: AppTypography.labelSmall.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
      child: child,
    );
  }

  Color _getBannerColor() {
    switch (AppEnvironment.current) {
      case Environment.development:
        return Colors.green;
      case Environment.staging:
        return Colors.orange;
      case Environment.production:
        return Colors.red;
    }
  }
}

/// Alternative: Bottom floating indicator badge
class EnvironmentIndicator extends StatelessWidget {
  const EnvironmentIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode and non-production environments
    if (!kDebugMode || AppEnvironment.isProduction) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getIndicatorColor(),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIndicatorIcon(),
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              AppEnvironment.name,
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getIndicatorColor() {
    switch (AppEnvironment.current) {
      case Environment.development:
        return Colors.green.shade700;
      case Environment.staging:
        return Colors.orange.shade700;
      case Environment.production:
        return Colors.red.shade700;
    }
  }

  IconData _getIndicatorIcon() {
    switch (AppEnvironment.current) {
      case Environment.development:
        return Icons.code;
      case Environment.staging:
        return Icons.science;
      case Environment.production:
        return Icons.public;
    }
  }
}
