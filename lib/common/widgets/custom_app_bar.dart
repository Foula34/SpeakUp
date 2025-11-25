import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../constants/app_text_styles.dart';

/// AppBar personnalisée de l'application SpeakUp
/// Basée sur le design system extrait de Google Stitch
/// 
/// Caractéristiques :
/// - Avatar utilisateur à gauche (cliquable)
/// - Titre "SpeakUp" centré
/// - Icône notification à droite (cliquable)
/// - Support du mode clair/sombre
/// - Hauteur : 64px
/// 
/// Exemple d'utilisation :
/// ```dart
/// CustomAppBar(
///   avatarUrl: 'https://...',
///   onNotificationTap: () => _openNotifications(),
///   onAvatarTap: () => _openProfile(),
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// URL de l'avatar de l'utilisateur
  final String? avatarUrl;
  
  /// Callback appelé lors du clic sur l'icône notification
  final VoidCallback? onNotificationTap;
  
  /// Callback appelé lors du clic sur l'avatar
  final VoidCallback? onAvatarTap;
  
  /// Affiche un badge sur l'icône notification
  final bool hasNotifications;

  const CustomAppBar({
    Key? key,
    this.avatarUrl,
    this.onNotificationTap,
    this.onAvatarTap,
    this.hasNotifications = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: isDark 
          ? AppColors.backgroundDark 
          : AppColors.backgroundLight,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: AppDimens.appBarHeight,
      
      // Avatar à gauche
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: avatarUrl != null 
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null 
                ? const Icon(
                    Icons.person,
                    color: AppColors.primary,
                  )
                : null,
          ),
        ),
      ),
      
      // Titre centré
      title: Text(
        'SpeakUp',
        style: AppTextStyles.h3.copyWith(
          color: isDark 
              ? AppColors.textPrimaryDark 
              : AppColors.textPrimaryLight,
        ),
      ),
      
      // Icône notification à droite
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: isDark 
                    ? AppColors.textPrimaryDark 
                    : AppColors.textPrimaryLight,
              ),
              onPressed: onNotificationTap,
            ),
            
            // Badge de notification
            if (hasNotifications)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
