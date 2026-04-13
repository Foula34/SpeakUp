import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as Math;

import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/glass_card.dart';
import '../../../common/widgets/gradient_button.dart';

/// Écran d'accueil principal de l'application SpeakUp (Version Premium)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Notifications (Mock)', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ListTile(
                leading: CircleAvatar(backgroundColor: AppColors.accent.withOpacity(0.2), child: const Icon(Icons.thumb_up, color: AppColors.accent, size: 20)),
                title: const Text('Amadou a aimé votre pitch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                subtitle: const Text('Il y a 2h', style: TextStyle(color: Colors.white54)),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.orangeAccent.withOpacity(0.2), child: const Icon(Icons.emoji_events, color: Colors.orangeAccent, size: 20)),
                title: const Text('Badge "Premier Pas" débloqué !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                subtitle: const Text('Hier', style: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userLevel = 2; // Temporaire

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Gradient Orbs (Ambiance)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scaleXY(begin: 1.0, end: 1.2, curve: Curves.easeInOut, duration: 4.seconds),
           
          Positioned(
            top: 200,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.15),
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scaleXY(begin: 1.2, end: 1.0, curve: Curves.easeInOut, duration: 5.seconds),

          // Main Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(context, userLevel),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildDailyChallenge(context),
                      const SizedBox(height: 48),
                      _buildCommunityTrends(context),
                      const SizedBox(height: 100), // Padding pour BottomNavBar
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// AppBar avec avatar, titre et notifications
  Widget _buildAppBar(BuildContext context, int userLevel) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 90,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.accent, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: const Center(
                child: Text('J', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Greet
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour, Jeanne',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Prête à briller ? ✨',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Notifications
            GestureDetector(
              onTap: () => _showNotifications(context),
              child: const GlassCard(
                padding: EdgeInsets.all(10),
                borderRadius: 16,
                width: 48,
                height: 48,
                child: Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  /// Carte "Défi du Jour" Premium
  Widget _buildDailyChallenge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: EdgeInsets.zero,
        borderRadius: 28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Art
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                    gradient: LinearGradient(
                      colors: [AppColors.primary, const Color(0xFF1E3A8A)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: CustomPaint(painter: WavePainter()),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 16),
                        SizedBox(width: 4),
                        Text('Nouveau', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Le Pouvoir du Storytelling',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Captez l\'attention en structurant votre pitch comme une histoire (2 min).',
                    style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.7), height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    text: 'Commencer la Pratique',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () {
                      context.push('/practice', extra: {'challengeTitle': 'Maîtriser le Storytelling'});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  /// Section "Tendances Communautaires"
  Widget _buildCommunityTrends(BuildContext context) {
    final trendingPosts = [
      {'title': 'Convaincre un investisseur en 30s', 'author': 'Amadou B.', 'duration': '3 min', 'color': const Color(0xFF6366F1), 'icon': Icons.rocket_launch},
      {'title': 'Mon retour sur l\'IA et le design', 'author': 'Fatou N.', 'duration': '2 min', 'color': const Color(0xFF10B981), 'icon': Icons.palette},
      {'title': 'Comment structurer son argumentaire', 'author': 'Moussa K.', 'duration': '4 min', 'color': const Color(0xFFF43F5E), 'icon': Icons.psychology},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Tendances',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Voir tout',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 240,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
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
                icon: post['icon'] as IconData,
              ).animate().fadeIn(delay: (300 + (index * 100)).ms).slideX(begin: 0.2, end: 0);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard(BuildContext context, {required String title, required String author, required String duration, required Color color, required IconData icon}) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        backgroundColor: color.withOpacity(0.15),
        borderColor: color.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.white.withOpacity(0.2), radius: 12, child: Text(author[0], style: const TextStyle(fontSize: 10, color: Colors.white))),
                const SizedBox(width: 8),
                Text(author, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                const Spacer(),
                Icon(Icons.timer_outlined, color: Colors.white.withOpacity(0.5), size: 14),
                const SizedBox(width: 4),
                Text(duration, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Painter Modernisé pour la Card
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.2, size.width * 0.6, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.8, size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
    
    final paint2 = Paint()
      ..color = AppColors.accent.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    final path2 = Path();
    path2.moveTo(size.width * 0.2, size.height);
    path2.quadraticBezierTo(size.width * 0.5, size.height * 0.3, size.width, size.height * 0.6);
    path2.lineTo(size.width, size.height);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
