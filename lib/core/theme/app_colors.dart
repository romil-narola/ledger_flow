import 'package:flutter/material.dart';

/// Color palette for LedgerFlow - Professional Blue/Indigo scheme
class AppColors {
  AppColors._();

  // ─── Brand Colors ────────────────────────────────────────────────
  static const Color primary = Color(0xFF1E3A8A); // Deep Blue
  static const Color primaryLight = Color(0xFF3B82F6); // Bright Blue
  static const Color primaryDark = Color(0xFF1E40AF); // Dark Blue

  static const Color secondary = Color(0xFF0F766E); // Teal
  static const Color secondaryLight = Color(0xFF14B8A6); // Bright Teal

  // ─── Status Colors ───────────────────────────────────────────────
  static const Color success = Color(0xFF059669); // Green
  static const Color successLight = Color(0xFF10B981);
  static const Color successBg = Color(0xFFD1FAE5);

  static const Color warning = Color(0xFFD97706); // Amber
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFDC2626); // Red
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF2563EB); // Blue
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoBg = Color(0xFFDBEAFE);

  // ─── Semantic Colors ─────────────────────────────────────────────
  static const Color outstanding = Color(0xFFDC2626); // Red - amount owed
  static const Color credit = Color(0xFF059669); // Green - advance/credit
  static const Color debit = Color(0xFFDC2626); // Red - debit
  static const Color creditEntry = Color(0xFF059669); // Green - credit entry

  // ─── Gradients ───────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF10B981)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
  );

  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
  );

  // ─── Light Mode ──────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1E293B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color inputFillLight = Color(0xFFF1F5F9);
  static const Color chipBgLight = Color(0xFFEFF6FF);
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textHintLight = Color(0xFF94A3B8);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF8FAFC);

  // ─── Dark Mode ───────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surface2Dark = Color(0xFF334155);
  static const Color onSurfaceDark = Color(0xFFF1F5F9);
  static const Color borderDark = Color(0xFF334155);
  static const Color inputFillDark = Color(0xFF0F172A);
  static const Color chipBgDark = Color(0xFF1E3A8A);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textHintDark = Color(0xFF475569);
  static const Color dividerDark = Color(0xFF334155);
  static const Color shimmerBaseDark = Color(0xFF334155);
  static const Color shimmerHighlightDark = Color(0xFF475569);

  // ─── Chart Colors ────────────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
    Color(0xFFEC4899),
  ];

  // ─── Avatar Colors ───────────────────────────────────────────────
  static const List<Color> avatarColors = [
    Color(0xFF1E3A8A),
    Color(0xFF059669),
    Color(0xFFD97706),
    Color(0xFFDC2626),
    Color(0xFF7C3AED),
    Color(0xFF0F766E),
    Color(0xFFDB2777),
    Color(0xFF0369A1),
  ];

  /// Get avatar color based on name hash
  static Color avatarColorForName(String name) {
    final index = name.isEmpty ? 0 : name.codeUnitAt(0) % avatarColors.length;
    return avatarColors[index];
  }
}
