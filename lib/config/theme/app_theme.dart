import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// FutbolAI tema tanımları — Dark (varsayılan) & Light
class AppTheme {
  AppTheme._();

  // ═══ Dark Theme (Varsayılan) ═══
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryColor,
          secondary: AppColors.accentColor,
          surface: AppColors.surfaceColor,
          error: AppColors.dangerColor,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: AppColors.textPrimary,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: AppTextStyles.textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorderColor),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceColor,
          selectedColor: AppColors.primaryColor.withValues(alpha: 0.2),
          labelStyle: AppTextStyles.textTheme.bodyMedium!.copyWith(
            color: AppColors.textPrimary,
          ),
          side: const BorderSide(color: AppColors.cardBorderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.cardBorderColor,
          thickness: 1,
        ),
      );

  // ═══ Light Theme ═══
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.accentColor,
          surface: AppColors.lightSurface,
          error: AppColors.dangerColor,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: AppColors.lightText,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.lightBg,
        textTheme: AppTextStyles.textTheme.apply(
          bodyColor: AppColors.lightText,
          displayColor: AppColors.lightText,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightSurface,
          foregroundColor: AppColors.lightText,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: AppColors.lightSurface,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.lightCardBorder),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedColor: AppColors.primaryColor.withValues(alpha: 0.1),
          labelStyle: AppTextStyles.textTheme.bodyMedium!.copyWith(
            color: AppColors.lightText,
          ),
          side: const BorderSide(color: AppColors.lightCardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lightCardBorder,
          thickness: 1,
        ),
      );
}
