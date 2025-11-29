import 'package:flutter/material.dart';
import '../../../common/constants/app_colors.dart';

/// Écran 7 : Community Feed (Fil d'Actualité)
/// 
/// Cet écran affiche :
/// - Les posts publiés par la communauté (table 'posts')
/// - Système de votes (👏 Clap / 👍 Like)
/// - Possibilité de commenter
/// - Filtrage par catégorie (Pitch, Opinion, etc.)
/// 
/// TODO SUPABASE:
/// - Charger les posts depuis la table 'posts' (ORDER BY created_at DESC)
/// - Implémenter le système de vote (table 'votes')
/// - Implémenter la pagination
/// - Gérer le filtrage par catégorie
class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        title: const Text(
          'Communauté',
          style: TextStyle(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Bouton de recherche
          IconButton(
            icon: const Icon(Icons.search),
            color: AppColors.textPrimaryLight,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recherche à venir')),
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
              Icon(
                Icons.people_outline,
                size: 80,
                color: AppColors.textSecondaryLight,
              ),
              const SizedBox(height: 24),
              Text(
                'Fil d\'Actualité',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'À implémenter prochainement',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 32),
              // TODO: Afficher la liste des posts
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '📝 Posts de la communauté\n'
                  '👏 Système de votes\n'
                  '💬 Commentaires structurés\n'
                  '📊 Classements',
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
      // Bouton Floating Action Button pour publier
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Naviguer vers l'écran de publication
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Publication à venir')),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Publier'),
      ),
    );
  }
}
