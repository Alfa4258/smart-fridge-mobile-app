import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryGreen,
    brightness: Brightness.light,
    primary: AppColors.primaryGreen,
    surface: AppColors.surfaceLight,
  );

  return ThemeData(
    colorScheme: colorScheme,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textDark,
      elevation: 2,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.white,
      elevation: 2,
    ),
  );
}

ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primaryGreen,
    brightness: Brightness.dark,
    primary: AppColors.primaryGreen,
    surface: AppColors.surfaceDark,
  );

  return ThemeData(
    colorScheme: colorScheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textDarkMode,
      elevation: 2,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.cardDark,
      elevation: 2,
    ),
  );
}
