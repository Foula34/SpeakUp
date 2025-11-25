import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_text_styles.dart';

/// Champ de saisie personnalisé de l'application
/// Basé sur le design system extrait de Google Stitch
/// 
/// Caractéristiques :
/// - Label au-dessus du champ
/// - Icône à gauche
/// - Hauteur : 56px
/// - Border radius : 8px
/// - Support du mode clair/sombre
/// - Placeholder grisé
/// - Focus ring bleu primaire
/// 
/// Exemple d'utilisation :
/// ```dart
/// CustomTextField(
///   label: 'Email',
///   placeholder: 'Entrez votre adresse email',
///   icon: Icons.mail_outline,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
class CustomTextField extends StatelessWidget {
  /// Label affiché au-dessus du champ
  final String label;
  
  /// Texte du placeholder
  final String placeholder;
  
  /// Icône affichée à gauche du champ
  final IconData icon;
  
  /// Contrôleur optionnel pour gérer le texte
  final TextEditingController? controller;
  
  /// Masque le texte (pour les mots de passe)
  final bool obscureText;
  
  /// Type de clavier à afficher
  final TextInputType? keyboardType;
  
  /// Widget optionnel affiché à droite (ex: toggle password visibility)
  final Widget? suffixIcon;
  
  /// Fonction de validation
  final String? Function(String?)? validator;
  
  /// Active ou désactive le champ
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: isDark 
                ? AppColors.textPrimaryDark 
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: AppDimens.spacingS),
        
        // TextField
        SizedBox(
          height: AppDimens.inputHeight,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            enabled: enabled,
            validator: validator,
            style: TextStyle(
              color: isDark 
                  ? AppColors.textPrimaryDark 
                  : AppColors.textPrimaryLight,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                color: isDark 
                    ? AppColors.textSecondaryDark 
                    : AppColors.textSecondaryLight,
              ),
              prefixIcon: Icon(
                icon,
                color: isDark 
                    ? AppColors.textSecondaryDark 
                    : AppColors.textSecondaryLight,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: isDark 
                  ? AppColors.surfaceDark.withOpacity(0.5)
                  : AppColors.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spacingM,
                vertical: AppDimens.spacingM,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
                borderSide: const BorderSide(
                  color: AppColors.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
