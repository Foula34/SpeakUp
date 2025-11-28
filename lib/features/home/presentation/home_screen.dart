import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as Math;

/// Écran d'accueil principal de l'application SpeakUp
/// Affiche : AppBar avec profil, Défi du jour, Tendances communautaires
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Récupérer le niveau de l'utilisateur depuis le provider
    final userLevel = 2; // Temporaire - sera dynamique plus tard

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Gris très clair
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar personnalisée
            _buildAppBar(context, userLevel),
            
            // Contenu principal
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Carte "Défi du Jour"
                  _buildDailyChallenge(context),
                  
                  const SizedBox(height: 32),
                  
                  // Section "Tendances Communautaires"
                  _buildCommunityTrends(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AppBar avec avatar, titre et notifications
  Widget _buildAppBar(BuildContext context, int userLevel) {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFFF5F5F5),
      elevation: 0,
      title: Row(
        children: [
          // Avatar à gauche
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D5C4), // Beige
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF8B7355),
              size: 28,
            ),
          ),
          
          const Spacer(),
          
          // Titre "SpeakUp" au centre
          const Text(
            'SpeakUp',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Spacer(),
          
          // Icône de notification à droite
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: Colors.black,
              onPressed: () {
                // TODO: Naviguer vers les notifications
              },
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Niveau $userLevel',
              style: const TextStyle(
                color: Color(0xFF6B7280), // Gris moyen
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
  /// Carte "Défi du Jour"
  Widget _buildDailyChallenge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image décorative avec courbes
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE8D5C4), // Beige clair
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Image des courbes (pour l'instant, on simule avec des Container)
                  // TODO: Remplacer par une vraie image plus tard
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WavePainter(),
                    ),
                  ),
                ],
              ),
            ),
            
            // Contenu texte
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Défi du Jour: Maîtriser le Storytelling',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Exercez-vous à raconter une histoire captivante en moins de 2 minutes.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  // Bouton "Commencer la Pratique"
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Naviguer vers l'écran de pratique
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB), // Bleu
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Commencer la Pratique 🚀',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section "Tendances Communautaires"
  Widget _buildCommunityTrends(BuildContext context) {
    // Données factices pour le MVP
    final trendingPosts = [
      {
        'title': 'L\'Avenir de l\'IA',
        'author': 'Alex Dupont',
        'duration': '3 min',
        'color': const Color(0xFF6366F1), // Bleu-violet
      },
      {
        'title': 'Mon Voyage Entrepreneurial',
        'author': 'Marie Curie',
        'duration': '2 min',
        'color': const Color(0xFF059669), // Vert
      },
      {
        'title': 'Changer le Monde',
        'author': 'Jean Martin',
        'duration': '4 min',
        'color': const Color(0xFFDC2626), // Rouge
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Tendances Communautaires',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Liste horizontale scrollable des posts
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: trendingPosts.length,
            itemBuilder: (context, index) {
              final post = trendingPosts[index];
              return _buildTrendingCard(
                context,
                title: post['title'] as String,
                author: post['author'] as String,
                duration: post['duration'] as String,
                color: post['color'] as Color,
              );
            },
          ),
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }

  /// Carte individuelle de tendance
  Widget _buildTrendingCard(
    BuildContext context, {
    required String title,
    required String author,
    required String duration,
    required Color color,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Image de fond avec dégradé
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.8),
                      color,
                    ],
                  ),
                ),
                // Pattern géométrique (simplifié pour le MVP)
                child: CustomPaint(
                  painter: GeometricPatternPainter(color: color),
                ),
              ),
            ),
            
            // Contenu texte
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Par $author',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter pour dessiner les courbes ondulées de la carte "Défi du Jour"
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4B5A0).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Dessiner plusieurs courbes ondulées
    for (int i = 0; i < 8; i++) {
      final path = Path();
      final offsetY = size.height * 0.2 + (i * size.height * 0.1);
      
      path.moveTo(0, offsetY);
      
      for (double x = 0; x <= size.width; x += 20) {
        final y = offsetY + 15 * Math.sin((x / size.width) * 2 * Math.pi + i * 0.5);
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Ajouter quelques points
    final dotPaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.4), 3, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.5), 3, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.45), 3, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.35), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter pour le pattern géométrique des cartes de tendances
class GeometricPatternPainter extends CustomPainter {
  final Color color;

  GeometricPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Créer un pattern de triangles
    const gridSize = 40.0;
    
    for (double x = 0; x < size.width; x += gridSize) {
      for (double y = 0; y < size.height; y += gridSize) {
        // Triangle vers le haut
        final path1 = Path()
          ..moveTo(x, y + gridSize)
          ..lineTo(x + gridSize / 2, y)
          ..lineTo(x + gridSize, y + gridSize)
          ..close();
        
        // Triangle vers le bas
        final path2 = Path()
          ..moveTo(x, y)
          ..lineTo(x + gridSize, y)
          ..lineTo(x + gridSize / 2, y + gridSize)
          ..close();
        
        // Alterner les triangles pour créer un pattern
        if ((x / gridSize + y / gridSize) % 2 == 0) {
          canvas.drawPath(path1, paint);
        } else {
          canvas.drawPath(path2, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
