import 'package:flutter/material.dart';

class AppSpacing {
  // Base unit - 4px grid system
  static const double unit = 4.0;

  // Spacing Scale
  static const double xs = unit; // 4px
  static const double sm = unit * 2; // 8px
  static const double md = unit * 4; // 16px
  static const double lg = unit * 6; // 24px
  static const double xl = unit * 8; // 32px
  static const double xxl = unit * 12; // 48px
  static const double xxxl = unit * 16; // 64px

  // Semantic Spacing
  static const double padding = md; // 16px - default padding
  static const double paddingSmall = sm; // 8px
  static const double paddingLarge = lg; // 24px

  static const double margin = md; // 16px - default margin
  static const double marginSmall = sm; // 8px
  static const double marginLarge = lg; // 24px

  static const double gap = md; // 16px - gap between elements
  static const double gapSmall = sm; // 8px
  static const double gapLarge = lg; // 24px

  // Component Specific
  static const double cardPadding = md;
  static const double cardMargin = md;
  static const double buttonPadding = md;
  static const double iconSize = lg;
  static const double iconSizeSmall = md;
  static const double iconSizeLarge = xl;

  // Edge Insets Presets
  static const EdgeInsets paddingAll = EdgeInsets.all(padding);
  static const EdgeInsets paddingAllSmall = EdgeInsets.all(paddingSmall);
  static const EdgeInsets paddingAllLarge = EdgeInsets.all(paddingLarge);

  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: padding);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: padding);

  static const EdgeInsets marginAll = EdgeInsets.all(margin);
  static const EdgeInsets marginAllSmall = EdgeInsets.all(marginSmall);
  static const EdgeInsets marginAllLarge = EdgeInsets.all(marginLarge);

  static const EdgeInsets marginHorizontal = EdgeInsets.symmetric(horizontal: margin);
  static const EdgeInsets marginVertical = EdgeInsets.symmetric(vertical: margin);

  // Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: md);
}

class AppBorderRadius {
  // Border Radius Scale - Sharp, minimal aesthetic
  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double xxl = 16.0;

  // Semantic Radius
  static const double button = sm; // Sharp, tech feel
  static const double card = md;
  static const double input = sm;
  static const double dialog = md;
  static const double bottomSheet = lg;

  // BorderRadius Presets
  static BorderRadius radiusXS = BorderRadius.circular(xs);
  static BorderRadius radiusSM = BorderRadius.circular(sm);
  static BorderRadius radiusMD = BorderRadius.circular(md);
  static BorderRadius radiusLG = BorderRadius.circular(lg);
  static BorderRadius radiusXL = BorderRadius.circular(xl);
  static BorderRadius radiusXXL = BorderRadius.circular(xxl);

  static BorderRadius radiusButton = BorderRadius.circular(button);
  static BorderRadius radiusCard = BorderRadius.circular(card);
  static BorderRadius radiusInput = BorderRadius.circular(input);
  static BorderRadius radiusDialog = BorderRadius.circular(dialog);
}

class AppElevation {
  // Elevation levels - Minimal use for flat design
  static const double none = 0.0;
  static const double xs = 1.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 12.0;

  // Semantic Elevation
  static const double card = xs; // Very subtle
  static const double button = none; // Flat
  static const double dialog = md;
  static const double bottomSheet = lg;
  static const double appBar = none; // Flat
}

class AppSizes {
  // Common component sizes
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;

  static const double inputHeight = 48.0;
  static const double inputHeightSmall = 36.0;
  static const double inputHeightLarge = 56.0;

  static const double iconButton = 48.0;
  static const double iconButtonSmall = 36.0;
  static const double iconButtonLarge = 56.0;

  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 56.0;

  static const double avatarSmall = 32.0;
  static const double avatarMedium = 48.0;
  static const double avatarLarge = 64.0;
  static const double avatarXLarge = 96.0;

  // Thumbnail sizes
  static const double thumbnailSmall = 80.0;
  static const double thumbnailMedium = 120.0;
  static const double thumbnailLarge = 200.0;
}
