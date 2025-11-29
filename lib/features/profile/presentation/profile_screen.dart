import 'package:flutter/material.dart';
import '../../../common/constants/app_colors.dart';

/// Écran 9 : Profile (Profil)
/// 
/// Cet écran affiche :
/// - Les informations du profil (avatar, nom, bio)
/// - Les statistiques (XP, niveau, badges)
/// - Le journal de progrès (accès aux sessions)
/// - Les paramètres
/// 
/// TODO SUPABASE:
/// - Charger les données du profil depuis la table 'users'
/// - Afficher les badges débloqués
/// - Gérer la modification du profil
/// - Implémenter la déconnexion
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Bouton Paramètres
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.textPrimaryLight,
            onPressed: () {
              // TODO: Naviguer vers l'écran des paramètres
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paramètres à venir')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar (placeholder)
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Nom de l'utilisateur
              // TODO SUPABASE: Charger depuis users.name
              Text(
                'Utilisateur',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              // Email de l'utilisateur
              // TODO SUPABASE: Charger depuis auth.user.email
              Text(
                'utilisateur@email.com',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 32),
              // Stats rapides
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(context, 'Niveau', '1'),
                    _buildStatItem(context, 'XP', '0'),
                    _buildStatItem(context, 'Badges', '0'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // TODO: Liste des actions (Journal, Badges, Paramètres, Déconnexion)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '📊 Journal de progrès\n'
                  '🏆 Mes badges\n'
                  '⚙️ Paramètres\n'
                  '🚪 Déconnexion',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
