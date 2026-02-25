import 'package:flutter/material.dart';

/// FutbolAI renk paleti — SPEC.md Bölüm 7.1
class AppColors {
  AppColors._();

  // ═══ Dark Theme ═══
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color accentColor = Color(0xFF00E5FF);
  static const Color backgroundColor = Color(0xFF0D1117);
  static const Color surfaceColor = Color(0xFF161B22);
  static const Color cardBorderColor = Color(0xFF30363D);
  static const Color successColor = Color(0xFF2EA043);
  static const Color warningColor = Color(0xFFE3B341);
  static const Color dangerColor = Color(0xFFF85149);
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);

  // ═══ Light Theme ═══
  static const Color lightBg = Color(0xFFF6F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1F2328);
  static const Color lightTextSecondary = Color(0xFF656D76);
  static const Color lightCardBorder = Color(0xFFD0D7DE);

  // ═══ Banko Level Colors ═══
  static const Color bankoColor = Color(0xFF2EA043);
  static const Color gucluColor = Color(0xFF3FB950);
  static const Color riskliColor = Color(0xFFE3B341);
  static const Color kapatColor = Color(0xFFF85149);

  // ═══ Gradient ═══
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient analyzeButtonGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D4EDD)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
