import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color brandPrimary = Color(0xFF6750A4);

  // Status Colors - Light
  static const Color successLight = Color(0xFF2E7D32);
  static const Color errorLight = Color(0xFFD32F2F);

  // Status Colors - Dark
  static const Color successDark = Color(0xFF81C784);
  static const Color errorDark = Color(0xFFE57373);

  // Deep Space Gradient (Dark Theme Card)
  static const List<Color> deepSpaceGradient = [
    Color(0xFF0F0C29),
    Color(0xFF302B63),
    Color(0xFF24243E),
  ];

  // Neutrals & Utility
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static const Color shadowDark = Color(0x33000000);
}

// ─── Dashboard Color Palette ─────────────────────────────────────────────────
// All colors used across the dashboard feature. Centralised here so the
// entire palette can be swapped for a different brand/season in one place.

class DashboardColors {
  DashboardColors._();

  // Backgrounds
  static const Color pageBg         = Color(0xFF1A0A00); // deepest bg
  static const Color appBarBg       = Color(0xFF2A0E00); // pinned bar + chip row
  static const Color headerGradTop  = Color(0xFF3D1200); // collapsible header top
  static const Color sectionDarkBg  = Color(0xFF0D0D0D); // bestsellers section
  static const Color cardDarkBg     = Color(0xFF1C1C1C); // bestseller card
  static const Color placeholderBg  = Color(0xFF2A2A2A); // empty product cell

  // Banner
  static const Color bannerLeft     = Color(0xFF5C1A00);
  static const Color bannerMid      = Color(0xFF8B2500);
  static const Color bannerVignette = Color(0x885C1A00); // side fade
  static const Color bannerGold     = Color(0xFFD4A843); // ornament / text

  // Promo cards
  static const Color promoCardBg    = Color(0xFF7B2D2D); // default card bg

  // Badges
  static const Color greenBadge     = Color(0xFF2A5C2A); // distance + wallet
  static const Color newBadge       = Colors.red;

  // Search bar
  static const Color searchBg       = Colors.white;
  static const Color searchDivider  = Color(0xFFE0E0E0);

  // Refresh indicator
  static const Color refreshBg      = Color(0xFF3D1A00);

  // Divider
  static const Color chipDivider    = Color(0x14FFFFFF); // white 8%
}

