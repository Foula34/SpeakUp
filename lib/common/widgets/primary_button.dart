import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_text_styles.dart';

/// Bouton principal de l'application (Bleu primaire)
/// Basé sur le design system extrait de Google Stitch
/// 
/// Caractéristiques :
/// - Fond bleu primaire (#1152D4)
/// - Texte blanc, Inter Semi-Bold 16px
/// - Hauteur : 56px
/// - Border radius : 8px
/// - Support du mode chargement avec CircularProgressIndicator
/// 
/// Exemple d'utilisation :
/// ```dart
/// PrimaryButton(
///   text: 'Créer mon compte',
///   onPressed: () => _handleSignup(),
///   icon: Icons.rocket_launch,
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  /// Texte affiché sur le bouton
  final String text;
  
  /// Callback appelé lors du clic
  final VoidCallback? onPressed;
  
  /// Indique si le bouton est en état de chargement
  final bool isLoading;
  
  /// Icône optionnelle affichée avant le texte
  final IconData? icon;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimens.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppDimens.iconS),
                    const SizedBox(width: AppDimens.spacingS),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }
}
