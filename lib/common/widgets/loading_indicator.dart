import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Indicateur de chargement personnalisé
/// Simple CircularProgressIndicator aux couleurs de l'app
class LoadingIndicator extends StatelessWidget {
  /// Taille de l'indicateur
  final double size;
  
  /// Couleur de l'indicateur
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
