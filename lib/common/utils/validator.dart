/// Classe contenant les fonctions de validation pour les formulaires
class Validator {
  // Empêcher l'instanciation
  Validator._();

  /// Valide une adresse email
  /// Retourne un message d'erreur si invalide, null sinon
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    
    // Pattern regex pour valider un email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    
    return null;
  }

  /// Valide un mot de passe
  /// Minimum 8 caractères requis
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    
    return null;
  }

  /// Valide que deux mots de passe correspondent
  static String? validatePasswordMatch(String? value, String? otherValue) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    
    if (value != otherValue) {
      return 'Les mots de passe ne correspondent pas';
    }
    
    return null;
  }

  /// Valide un nom d'utilisateur
  /// 3 à 30 caractères, lettres, chiffres, tirets et underscores uniquement
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom d\'utilisateur est requis';
    }
    
    if (value.length < 3) {
      return 'Le nom d\'utilisateur doit contenir au moins 3 caractères';
    }
    
    if (value.length > 30) {
      return 'Le nom d\'utilisateur ne peut pas dépasser 30 caractères';
    }
    
    // Autorise uniquement lettres, chiffres, tirets et underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    
    if (!usernameRegex.hasMatch(value)) {
      return 'Le nom d\'utilisateur ne peut contenir que des lettres, chiffres, - et _';
    }
    
    return null;
  }

  /// Valide un champ texte requis
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  /// Valide une durée minimale (en secondes)
  static String? validateMinDuration(int? value, int minSeconds) {
    if (value == null || value < minSeconds) {
      return 'La durée minimale est de $minSeconds secondes';
    }
    return null;
  }
}
