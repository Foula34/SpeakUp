import 'package:flutter/material.dart';

/// Classe contenant tous les styles de texte de l'application
/// Police : Inter (utilisée dans tout le design Stitch)
class AppTextStyles {
  // Empêcher l'instanciation
  AppTextStyles._();

  /// Police de caractères principale de l'application
  static const String fontFamily = 'Inter';
  
  // ========== HEADLINES (Titres principaux) ==========
  
  /// H1 : Titres de page principaux (32px, Bold)
  /// Exemple : "Créez votre compte"
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.48,
    height: 1.2,
  );
  
  /// H2 : Sous-titres importants (24px, Bold)
  /// Exemple : "SpeakUp" dans l'en-tête
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.36,
    height: 1.3,
  );
  
  /// H3 : Titres de sections (20px, Bold)
  /// Exemple : "Tendances Communautaires"
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  /// H4 : Sous-titres de cartes (18px, Bold)
  /// Exemple : Titre d'une carte de contenu
  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.27,
    height: 1.3,
  );
  
  // ========== BODY TEXT (Textes de corps) ==========
  
  /// Body Large : Texte principal (16px, Normal)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  /// Body Medium : Texte secondaire (14px, Normal)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );
  
  /// Body Small : Petit texte, metadata (12px, Normal)
  /// Exemple : "Par Alex Dupont • 3 min"
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  // ========== LABELS & BUTTONS ==========
  
  /// Button : Texte de bouton (16px, Semi-Bold)
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  /// Label : Labels de formulaires (14px, Medium)
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  // ========== SPECIAL (Écrans spéciaux) ==========
  
  /// Splash Title : Grand titre du splash screen (48px, Bold)
  /// Exemple : "SpeakUp"
  static const TextStyle splashTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.72,
    height: 1.1,
  );
  
  /// Splash Subtitle : Sous-titre du splash screen (18px, Normal)
  /// Exemple : "Votre voix, votre confiance."
  static const TextStyle splashSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );
  
  /// Timer : Affichage du chronomètre (48px, Bold)
  /// Exemple : "00:00 / 02:00"
  static const TextStyle timer = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.1,
  );
}
