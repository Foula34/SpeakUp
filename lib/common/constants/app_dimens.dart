/// Classe contenant toutes les dimensions et espacements de l'application
/// Basée sur le design system extrait de Google Stitch
class AppDimens {
  // Empêcher l'instanciation
  AppDimens._();

  // ========== ESPACEMENTS ==========
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  
  // ========== BORDER RADIUS ==========
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusFull = 999.0;
  
  // ========== HAUTEURS DE COMPOSANTS ==========
  /// Hauteur standard des boutons (56dp = 14 * 4 = h-14 en Tailwind)
  static const double buttonHeight = 56.0;
  
  /// Hauteur standard des champs de saisie
  static const double inputHeight = 56.0;
  
  /// Hauteur de l'AppBar
  static const double appBarHeight = 64.0;
  
  /// Hauteur de la bottom navigation bar
  static const double bottomNavHeight = 72.0;
  
  // ========== TAILLES D'ICÔNES ==========
  static const double iconXs = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXl = 48.0;
  
  // ========== AVATARS ==========
  static const double avatarS = 32.0;
  static const double avatarM = 40.0;
  static const double avatarL = 64.0;
  static const double avatarXl = 96.0;
  
  // ========== PADDING D'ÉCRAN ==========
  /// Padding horizontal standard des écrans
  static const double screenPaddingH = 16.0;
  
  /// Padding vertical standard des écrans
  static const double screenPaddingV = 16.0;
  
  // ========== AUTRES ==========
  /// Largeur maximale pour les contenus (responsive)
  static const double maxContentWidth = 600.0;
  
  /// Hauteur du splash screen logo
  static const double splashLogoSize = 120.0;
  
  /// Taille du bouton REC
  static const double recordButtonSize = 80.0;
}
