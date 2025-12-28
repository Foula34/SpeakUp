/// Modèle représentant un utilisateur dans l'application
/// Correspond à la table 'users' dans Supabase
class UserProfile {
  final String id;
  final String name;
  final String? bio;
  final String? avatarUrl;
  final int xp;
  final int level;
  final List<String> badges;
  final bool isPremium;
  final int currentStreak; // Nombre de jours consécutifs d'entraînement

  UserProfile({
    required this.id,
    required this.name,
    this.bio,
    this.avatarUrl,
    required this.xp,
    required this.level,
    required this.badges,
    required this.isPremium,
    this.currentStreak = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      badges: (json['badges'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isPremium: json['is_premium'] as bool? ?? false,
      currentStreak: json['current_streak'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatar_url': avatarUrl,
      'xp': xp,
      'level': level,
      'badges': badges,
      'is_premium': isPremium,
      'current_streak': currentStreak,
    };
  }

  double get progressToNextLevel {
    final xpForCurrentLevel = (level - 1) * 100;
    final xpForNextLevel = level * 100;
    final xpInCurrentLevel = xp - xpForCurrentLevel;
    final xpNeededForLevel = xpForNextLevel - xpForCurrentLevel;
    return (xpInCurrentLevel / xpNeededForLevel).clamp(0.0, 1.0);
  }

  int get xpToNextLevel {
    final xpForNextLevel = level * 100;
    return xpForNextLevel - xp;
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatarUrl,
    int? xp,
    int? level,
    List<String>? badges,
    bool? isPremium,
    int? currentStreak,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      isPremium: isPremium ?? this.isPremium,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}

class UserBadge {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final BadgeCondition condition;

  UserBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.condition,
  });
}

class BadgeCondition {
  final String type;
  final dynamic value;

  BadgeCondition({required this.type, this.value});
}

class AppBadges {
  static final List<UserBadge> allBadges = [
    UserBadge(
      id: 'no_filler',
      name: 'No Filler',
      description: 'Aucun mot de remplissage sur une session de 2 min',
      iconPath: 'assets/icons/badge_nofiller.svg',
      condition: BadgeCondition(type: 'fillers', value: 0),
    ),
    UserBadge(
      id: 'first_session',
      name: 'Premier Pas',
      description: 'Complétez votre première session',
      iconPath: 'assets/icons/badge_first.svg',
      condition: BadgeCondition(type: 'sessions', value: 1),
    ),
    UserBadge(
      id: 'speed_demon',
      name: 'Orateur Rapide',
      description: 'Atteignez 180 mots/min',
      iconPath: 'assets/icons/badge_speed.svg',
      condition: BadgeCondition(type: 'wpm', value: 180),
    ),
    UserBadge(
      id: 'consistent',
      name: 'Régulier',
      description: 'Pratiquez 7 jours d\'affilée',
      iconPath: 'assets/icons/badge_consistent.svg',
      condition: BadgeCondition(type: 'streak', value: 7),
    ),
    UserBadge(
      id: 'community_star',
      name: 'Star Communautaire',
      description: 'Recevez 100 votes',
      iconPath: 'assets/icons/badge_star.svg',
      condition: BadgeCondition(type: 'votes', value: 100),
    ),
  ];
}