import 'package:flutter/material.dart';
import '../common/constants/app_colors.dart';
import '../common/constants/app_text_styles.dart';

/// Configuration principale de l'application SpeakUp
/// Gère le thème (clair/sombre), le router, et l'initialisation de Supabase
class SpeakUpApp extends StatelessWidget {
  const SpeakUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeakUp',
      debugShowCheckedModeBanner: false,
      
      // Thème clair
      theme: _buildLightTheme(),
      
      // Thème sombre
      darkTheme: _buildDarkTheme(),
      
      // Mode système par défaut
      themeMode: ThemeMode.system,
      
      // TODO: Ajouter GoRouter pour la navigation
      home: const Scaffold(
        body: Center(
          child: Text('SpeakUp - App en construction'),
        ),
      ),
    );
  }

  /// Construit le thème clair de l'application
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Palette de couleurs
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        background: AppColors.backgroundLight,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onBackground: AppColors.textPrimaryLight,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),
      
      // Couleur de fond du Scaffold
      scaffoldBackgroundColor: AppColors.backgroundLight,
      
      // Police de caractères
      fontFamily: AppTextStyles.fontFamily,
      
      // Styles de texte
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        displayMedium: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        displaySmall: AppTextStyles.h3.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        headlineMedium: AppTextStyles.h4.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryLight,
        ),
      ),
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.textPrimaryLight,
        ),
      ),
      
      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  /// Construit le thème sombre de l'application
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Palette de couleurs
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        background: AppColors.backgroundDark,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onBackground: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      
      // Couleur de fond du Scaffold
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      // Police de caractères
      fontFamily: AppTextStyles.fontFamily,
      
      // Styles de texte
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: AppTextStyles.h2.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: AppTextStyles.h3.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: AppTextStyles.h4.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.textPrimaryDark,
        ),
      ),
      
      // Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}
