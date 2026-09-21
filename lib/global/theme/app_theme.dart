import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ==========================================
  // 60% — Light Canvas Foundation (White / Clean Off-White)
  // ==========================================
  static const Color primaryBackground =
      Color(0xFFF8FAFC); // Main page background, scaffold canvas (Slate-50)
  static const Color deepBackground =
      Color(0xFFF1F5F9); // Clean secondary backdrop, headers, breadcrumbs (Slate-100)
  static const Color darkerBackground =
      Color(0xFFE2E8F0); // Subtle darker neutral (Slate-200)

  // ==========================================
  // 30% — White & Light Neutral Surfaces
  // ==========================================
  static const Color softCharcoal =
      Color(0xFFFFFFFF); // Navigation bars, headers, sidebars, appbars (Pure White)
  static const Color darkGrey =
      Color(0xFFF8FAFC); // Inner containers, card tiles, input fields, pill buttons
  static const Color mutedSurface =
      Color(0xFFFFFFFF); // Cards, modals, elevated surfaces (Pure White)
  static const Color secondaryMaroon =
      Color(0xFFFEE2E2); // Soft red highlight tint for active sidebar/menu cards (Red-100)

  // ==========================================
  // Sidebar Red Theme (Enterprise Brand Red)
  // ==========================================
  static const Color sidebarBackground =
      Color(0xFFB91C1C); // Deep rich enterprise red (Red-700)
  static const Color sidebarBackgroundDark =
      Color(0xFF991B1B); // Darker red for header/footer (Red-800)
  static const Color sidebarBorder =
      Color(0x33FFFFFF); // 20% white subtle divider
  static const Color sidebarActiveItem =
      Color(0x33FFFFFF); // 20% white active highlight
  static const Color sidebarHoverItem =
      Color(0x1AFFFFFF); // 10% white hover highlight

  // Borders & Dividers
  static const Color border =
      Color(0xFFE2E8F0); // Standard border/divider: Slate-200
  static const Color borderSubtle =
      Color(0xFFF1F5F9); // Subtle border: Slate-100
  static const Color borderMedium =
      Color(0xFFCBD5E1); // Medium border: Slate-300
  static const Color borderLight =
      Color(0xFFE2E8F0); // Light border

  // ==========================================
  // 10% — Red Accent (Yamaha / STSJ Professional Brand Red)
  // ==========================================
  static const Color primaryRed =
      Color(0xFFDC2626); // Brand Primary Red (Red-600)
  static const Color accentYellow =
      Color(0xFFDC2626); // Primary action, CTA buttons, active indicators (Red alias)
  static const Color accentYellowHover =
      Color(0xFFB91C1C); // Hover state (Red-700)
  static const Color accentYellowPressed =
      Color(0xFF991B1B); // Pressed / active state (Red-800)
  static const Color onAccentYellow =
      Color(0xFFFFFFFF); // High contrast text on red background (Pure White)

  // Secondary Accents & Status Alerts
  static const Color accentDeepRed = Color(0xFFB91C1C);
  static const Color accentMint =
      Color(0xFF0D9488); // Status Positive / Success Teal
  static const Color accentGreen = Color(0xFF16A34A);
  static const Color accentPurple = Color(0xFF7C3AED);
  static const Color accentCoral = Color(0xFFE11D48); // Warning / Error Red-Rose

  // Typography (Dark Slate for Light Mode)
  static const Color textPrimary =
      Color(0xFF0F172A); // High contrast dark slate (Slate-900)
  static const Color textSecondary =
      Color(0xFF475569); // Readable muted grey/slate (Slate-600)
  static const Color textMuted =
      Color(0xFF94A3B8); // Hints, secondary labels (Slate-400)
  static const Color textDisabled =
      Color(0xFFCBD5E1); // Disabled text (Slate-300)

  // Backward compatibility aliases for existing codebase
  static const Color chineseBlack = primaryBackground;
  static const Color raisinBlack = softCharcoal;
  static const Color surfaceCard = mutedSurface;
  static const Color surfaceLighter = darkGrey;
  static const Color surfaceHighlight = secondaryMaroon;
}

class AppRadii {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double pill = 999.0;
  static const double full = 999.0;
}

class AppTheme {
  /// Global font configuration using Google Fonts (Light Mode).
  static TextTheme get _globalTextTheme {
    return GoogleFonts.soraTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.primaryBackground,
      cardColor: AppColors.mutedSurface,
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.mutedSurface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: AppColors.border,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryRed,
        onPrimary: AppColors.onAccentYellow,
        secondary: AppColors.primaryRed,
        onSecondary: Colors.white,
        error: AppColors.accentCoral,
        onError: Colors.white,
        surface: AppColors.mutedSurface,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.softCharcoal,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.mutedSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkGrey,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        labelStyle:
            const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide:
              const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide:
              const BorderSide(color: AppColors.accentCoral, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.onAccentYellow,
          textStyle: GoogleFonts.sora(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          textStyle: GoogleFonts.sora(
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.softCharcoal,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        textStyle: GoogleFonts.sora(color: AppColors.textPrimary),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
      ),
      textTheme: _globalTextTheme,
    );
  }

  // Alias for backward compatibility
  static ThemeData get darkTheme => lightTheme;
}
