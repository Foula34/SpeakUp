import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/constants/app_colors.dart';
import '../../../common/constants/app_routes.dart';
import '../../../common/widgets/glass_card.dart';

/// Écran 7 : Community Feed (Version Premium)
class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  // Mock Data for the Feed
  late List<Map<String, dynamic>> posts;

  @override
  void initState() {
    super.initState();
    posts = [
      {
        'author': 'Alex D.', 'role': 'Investisseur', 'time': 'Il y a 2h',
        'title': 'Analyse de mon pitch Start-up',
        'content': 'J\'ai besoin de retours sur l\'intro. Est-ce que le problème est clairement exposé ?',
        'tags': ['Pitch', 'Série A'], 'likes': 84, 'comments': 12, 'duration': '02:15'
      },
      {
        'author': 'Sarah L.', 'role': 'Étudiante', 'time': 'Il y a 4h',
        'title': 'Débat : L\'IA générative en école d\'art',
        'content': 'Un petit entraînement argumentatif sur l\'impact de Midjourney sur notre cursus.',
        'tags': ['Débat', 'Tech'], 'likes': 56, 'comments': 28, 'duration': '04:30'
      },
      {
        'author': 'Thomas B.', 'role': 'Manager', 'time': 'Hier',
        'title': 'Annonce restructuration équipe',
        'content': 'Comment annoncer une réorganisation sans créer de panique ? Voici mon essai.',
        'tags': ['Management', 'Opinion'], 'likes': 120, 'comments': 45, 'duration': '03:00'
      },
    ];
  }

  void _handleLike(int index) {
    setState(() {
      final isLiked = posts[index]['isLiked'] == true;
      if (isLiked) {
        posts[index]['likes']--;
        posts[index]['isLiked'] = false;
      } else {
        posts[index]['likes']++;
        posts[index]['isLiked'] = true;
      }
    });
  }

  void _showMockAction(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.report, color: Colors.orangeAccent),
              title: const Text('Signaler ce post', style: TextStyle(color: Colors.white)),
              onTap: () { context.pop(); _showMockAction('Post signalé'); },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.white54),
              title: const Text('Masquer cet utilisateur', style: TextStyle(color: Colors.white)),
              onTap: () { context.pop(); _showMockAction('Utilisateur masqué'); },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Subtle Animated Background Gradients
          Positioned(
            top: 50, right: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.2)),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(end: 1.5, duration: 6.seconds),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _buildPostCard(context, posts[index], index)
                              .animate()
                              .fadeIn(delay: (100 * index).ms)
                              .slideY(begin: 0.1, end: 0),
                        );
                      },
                      childCount: posts.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.publish),
        backgroundColor: Colors.transparent,
        elevation: 0,
        extendedPadding: EdgeInsets.zero,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.accent, AppColors.primary]),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: const Row(
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text('Publier', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: const Text(
        'Communauté',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => _showMockAction('Mock: Ouverture de la recherche'),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () => _showMockAction('Mock: Affichage des filtres'),
        ),
      ],
    );
  }

  Widget _buildPostCard(BuildContext context, Map<String, dynamic> post, int index) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.comments),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, Time
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withOpacity(0.3),
                  child: Text((post['author'] as String)[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['author'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${post['role']} • ${post['time']}', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_horiz, color: Colors.white54), onPressed: () => _showMoreOptions(context)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Title & Content
            Text(post['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(post['content'] as String, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.4)),
            const SizedBox(height: 16),

            // Audio Player Placeholder
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Forme d'onde (Ligne)
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.accent, Colors.white.withOpacity(0.2)]),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(post['duration'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tags
            Wrap(
              spacing: 8,
              children: (post['tags'] as List<String>).map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                ),
                child: Text(t, style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
              )).toList(),
            ),
            const SizedBox(height: 20),

            // Actions (Like, Comment)
            Row(
              children: [
                _buildActionButton(Icons.thumb_up_alt_outlined, '${post['likes']}',
                    isLiked: post['isLiked'] == true, onTap: () => _handleLike(index)),
                const SizedBox(width: 24),
                _buildActionButton(Icons.chat_bubble_outline, '${post['comments']}', onTap: () => context.push(AppRoutes.comments)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.bookmark_border, color: Colors.white54, size: 20), onPressed: () => _showMockAction('Mock: Sauvegardé')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {bool isLiked = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(isLiked ? Icons.thumb_up : icon, color: isLiked ? AppColors.accent : Colors.white54, size: 20),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isLiked ? AppColors.accent : Colors.white54, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
