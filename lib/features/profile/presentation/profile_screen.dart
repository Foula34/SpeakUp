import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../models/user_model.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101622) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF101622) : const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Pas de bouton retour
        title: Text(
          'Profil',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF212529),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: isDark ? Colors.white : const Color(0xFF212529),
            ),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.user == null
                ? _buildErrorState(isDark)
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildProfileHeader(state.user!, isDark),
                        _buildProgressBar(state.user!, isDark),
                        _buildTabNavigation(isDark),
                        _buildTabContent(state, isDark),
                      ],
                    ),
                  ),
      ),
    );
  }

  // En-tête du profil avec photo, nom, bio, niveau et streak
  Widget _buildProfileHeader(UserProfile user, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Photo de profil avec bordure
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0A2463), // Primary du design HTML
                width: 4,
              ),
            ),
            child: ClipOval(
              child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? Image.network(
                      user.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar(user.name);
                      },
                    )
                  : _buildDefaultAvatar(user.name),
            ),
          ),
          const SizedBox(height: 16),
          // Nom
          Text(
            user.name,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF212529),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Bio
          if (user.bio != null && user.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                user.bio!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF6C757D),
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          const SizedBox(height: 12),
          // Badge Niveau et Streak
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge Niveau
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A2463).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.school,
                      size: 16,
                      color: Color(0xFF0A2463),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Niveau : ${_getLevelName(user.level)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0A2463),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Badge Streak
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E92CC).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Color(0xFF3E92CC),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${user.currentStreak} jours',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3E92CC),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Avatar par défaut avec initiale
  Widget _buildDefaultAvatar(String name) {
    return Container(
      color: const Color(0xFFD4C5A9),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0A2463),
        ),
      ),
    );
  }

  // Obtenir le nom du niveau
  String _getLevelName(int level) {
    if (level <= 3) return 'Débutant';
    if (level <= 6) return 'Intermédiaire';
    if (level <= 10) return 'Avancé';
    return 'Expert';
  }

  // Barre de progression XP
  Widget _buildProgressBar(UserProfile user, bool isDark) {
    final xpForCurrentLevel = (user.level - 1) * 100;
    final xpForNextLevel = user.level * 100;
    final xpInCurrentLevel = user.xp - xpForCurrentLevel;
    final xpNeededForLevel = xpForNextLevel - xpForCurrentLevel;
    final progress = (xpInCurrentLevel / xpNeededForLevel).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progression de Niveau',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF6C757D),
                ),
              ),
              Text(
                '${user.xp}/$xpForNextLevel XP',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A2463),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Barre de progression
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3F3F46) : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A2463),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Système d'onglets
  Widget _buildTabNavigation(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3F3F46) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: isDark ? const Color(0xFF101622) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: const Color(0xFF0A2463),
          unselectedLabelColor: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF6C757D),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Mes Badges'),
            Tab(text: 'Mes Publications'),
          ],
        ),
      ),
    );
  }

  // Contenu des onglets
  Widget _buildTabContent(ProfileState state, bool isDark) {
    return SizedBox(
      height: 500, // Hauteur fixe pour le contenu
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildBadgesTab(state.user!, isDark),
          _buildPublicationsTab(isDark),
        ],
      ),
    );
  }

  // Onglet Badges
  Widget _buildBadgesTab(UserProfile user, bool isDark) {
    final unlockedBadges = AppBadges.allBadges.where((badge) => user.badges.contains(badge.id)).toList();
    final lockedBadges = AppBadges.allBadges.where((badge) => !user.badges.contains(badge.id)).toList();
    final allBadges = [...unlockedBadges, ...lockedBadges];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Ajusté de 0.85 pour éviter l'overflow
        ),
        itemCount: allBadges.length,
        itemBuilder: (context, index) {
          final badge = allBadges[index];
          final isUnlocked = user.badges.contains(badge.id);
          return _buildBadgeItem(badge, isUnlocked, isDark);
        },
      ),
    );
  }

  // Badge item
  Widget _buildBadgeItem(UserBadge badge, bool isUnlocked, bool isDark) {
    IconData icon;
    
    // Mapper les badges aux icônes
    switch (badge.id) {
      case 'no_filler':
        icon = Icons.mic_off;
        break;
      case 'consistent':
        icon = Icons.calendar_month;
        break;
      case 'first_session':
        icon = Icons.check_circle;
        break;
      case 'speed_demon':
        icon = Icons.speed;
        break;
      case 'community_star':
        icon = Icons.auto_stories;
        break;
      default:
        icon = Icons.emoji_events;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cercle avec icône
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isUnlocked
                ? const Color(0xFF3E92CC).withOpacity(0.2)
                : isDark
                    ? const Color(0xFF3F3F46)
                    : const Color(0xFFE5E7EB),
          ),
          child: Icon(
            isUnlocked ? icon : Icons.lock,
            size: 40,
            color: isUnlocked
                ? const Color(0xFF3E92CC)
                : isDark
                    ? const Color(0xFF71717A)
                    : const Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 8),
        // Nom du badge
        Expanded(
          child: Text(
            badge.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isUnlocked
                  ? (isDark ? Colors.white : const Color(0xFF212529))
                  : (isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF)),
            ),
          ),
        ),
      ],
    );
  }

  // Onglet Publications (avec des publications témoins)
  Widget _buildPublicationsTab(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          _buildPublicationCard(
            title: 'Mon premier pitch startup',
            category: 'Pitch',
            duration: 120,
            votesCount: 42,
            commentsCount: 8,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildPublicationCard(
            title: 'Opinion sur l\'IA et l\'éducation',
            category: 'Opinion',
            duration: 90,
            votesCount: 28,
            commentsCount: 5,
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          // Message si aucune publication
          Center(
            child: Text(
              'Ces publications sont des exemples',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Carte de publication
  Widget _buildPublicationCard({
    required String title,
    required String category,
    required int duration,
    required int votesCount,
    required int commentsCount,
    required DateTime createdAt,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et catégorie
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF212529),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A2463).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0A2463),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Icône type média
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E92CC).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.videocam,
                  size: 24,
                  color: Color(0xFF3E92CC),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Informations
          Row(
            children: [
              // Durée
              Icon(
                Icons.access_time,
                size: 16,
                color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                '${duration}s',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(width: 16),
              // Votes
              Icon(
                Icons.thumb_up,
                size: 16,
                color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                '$votesCount',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(width: 16),
              // Commentaires
              Icon(
                Icons.comment,
                size: 16,
                color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                '$commentsCount',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
                ),
              ),
              const Spacer(),
              // Date
              Text(
                _formatDate(createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Formater la date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // État d'erreur
  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: isDark ? const Color(0xFF71717A) : const Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF212529),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Impossible de charger le profil',
            style: TextStyle(
              color: isDark ? const Color(0xFF71717A) : const Color(0xFF6C757D),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(profileProvider.notifier).loadProfile();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A2463),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
