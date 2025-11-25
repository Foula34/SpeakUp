import 'package:flutter/material.dart';

/// Classe contenant toutes les couleurs de l'application SpeakUp
/// Basée sur le design system extrait de Google Stitch
class AppColors {
  // Empêcher l'instanciation
  AppColors._();

  // Couleur primaire (Bleu)
  static const Color primary = Color(0xFF1152D4);
  
  // Backgrounds
  static const Color backgroundLight = Color(0xFFF6F6F8);
  static const Color backgroundDark = Color(0xFF101622);
  
  // Textes (Light Mode)
  static const Color textPrimaryLight = Color(0xFF111318);
  static const Color textSecondaryLight = Color(0xFF616F89);
  
  // Textes (Dark Mode)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  
  // Surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF101622);
  
  // Bordures
  static const Color borderLight = Color(0xFFD4D4D8);
  static const Color borderDark = Color(0xFF3F3F46);
  
  // États
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  
  // Bouton REC (Rouge)
  static const Color recordButton = Color(0xFFEF4444);
  
  // Transparences utiles
  static const Color overlay = Color(0x80000000); // Noir 50% transparent
  static const Color shimmer = Color(0xFFE0E0E0);
}
