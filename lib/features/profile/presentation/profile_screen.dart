import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/profile_provider.dart';
import '../models/user_model.dart';
import '../../../common/constants/app_routes.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/glass_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Ambient background
          Positioned(
            top: -150, left: -50,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accent.withOpacity(0.15)),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 1.0, end: 1.2, duration: 4.seconds),
          
          SafeArea(
            child: state.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
              : state.user == null
                  ? _buildErrorState()
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        _buildAppBar(),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              _buildProfileHeader(state.user!).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                              const SizedBox(height: 24),
                              _buildTabNavigation().animate().fadeIn(delay: 200.ms),
                              _buildTabContent(state).animate().fadeIn(delay: 300.ms),
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

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text('Profil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
      actions: [
        IconButton(
          icon: const Icon(Icons.leaderboard_outlined, color: Colors.white),
          onPressed: () => context.push(AppRoutes.leaderboard),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(UserProfile user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Avatar + Animated XP Ring
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: user.progressToNextLevel),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    );
                  },
                ),
              ),
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  image: user.avatarUrl != null && user.avatarUrl!.isNotEmpty 
                    ? DecorationImage(image: NetworkImage(user.avatarUrl!), fit: BoxFit.cover) 
                    : null,
                ),
                child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                  ? Center(child: Text((user.name ?? 'U')[0].toUpperCase(), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)))
                  : null,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(user.name ?? 'Utilisateur', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(user.bio!, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7))),
          ],
          const SizedBox(height: 20),

          // Stats in GlassCard
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            borderRadius: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Niveau', '${user.level}', Icons.auto_awesome),
                Container(width: 1, height: 40, color: Colors.white.withOpacity(0.2)),
                _buildStatItem('Streak', '${user.currentStreak}j', Icons.local_fire_department, color: Colors.orangeAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {Color color = AppColors.accent}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildTabNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          tabs: const [Tab(text: 'Badges'), Tab(text: 'Publications')],
        ),
      ),
    );
  }

  Widget _buildTabContent(ProfileState state) {
    return SizedBox(
      height: 400, // Hauteur fixe pour le contenu pour éviter Scaffold error
      child: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildBadgesTab(state.user!),
          _buildPublicationsTab(),
        ],
      ),
    );
  }

  Widget _buildBadgesTab(UserProfile user) {
    final unlockedBadges = AppBadges.allBadges.where((b) => user.badges.contains(b.id)).toList();
    final lockedBadges = AppBadges.allBadges.where((b) => !user.badges.contains(b.id)).toList();
    final allBadges = [...unlockedBadges, ...lockedBadges];

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8
      ),
      itemCount: allBadges.length,
      itemBuilder: (context, index) {
        final badge = allBadges[index];
        final isUnlocked = user.badges.contains(badge.id);
        return _buildBadgeItem(badge, isUnlocked).animate().fadeIn(delay: (100 * index).ms).scale(curve: Curves.easeOutBack);
      },
    );
  }

  Widget _buildBadgeItem(UserBadge badge, bool isUnlocked) {
    IconData icon;
    switch (badge.id) {
      case 'no_filler': icon = Icons.mic_off; break;
      case 'consistent': icon = Icons.calendar_month; break;
      case 'first_session': icon = Icons.check_circle; break;
      case 'speed_demon': icon = Icons.speed; break;
      case 'community_star': icon = Icons.auto_stories; break;
      default: icon = Icons.emoji_events;
    }

    return Column(
      children: [
        Container(
          width: 70, height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked ? AppColors.accent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
            border: Border.all(color: isUnlocked ? AppColors.accent : Colors.white.withOpacity(0.1), width: 1.5),
          ),
          child: Icon(isUnlocked ? icon : Icons.lock, size: 32, color: isUnlocked ? AppColors.accent : Colors.white.withOpacity(0.3)),
        ),
        const SizedBox(height: 8),
        Text(badge.name, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isUnlocked ? Colors.white : Colors.white.withOpacity(0.4))),
      ],
    );
  }

  Widget _buildPublicationsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mon premier pitch startup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Pitch', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.thumb_up_outlined, size: 14, color: Colors.white54), const SizedBox(width: 4),
                  const Text('42', style: TextStyle(color: Colors.white54, fontSize: 12)), const SizedBox(width: 16),
                  const Icon(Icons.chat_bubble_outline, size: 14, color: Colors.white54), const SizedBox(width: 4),
                  const Text('8', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const Spacer(),
                  const Text('Aujourd\'hui', style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              )
            ],
          ),
        ).animate().fadeIn().slideX(),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.white54),
          const SizedBox(height: 16),
          const Text('Erreur de chargement', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.read(profileProvider.notifier).loadProfile(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
