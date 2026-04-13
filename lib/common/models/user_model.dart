/// Modèle unifié représentant un utilisateur de l'application
///
/// Correspond à la table 'users' dans Supabase.
/// Ce modèle est utilisé à la fois pour l'authentification et le profil.
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? bio;
  final String? avatarUrl;
  final int xp;
  final int level;
  final List<String> badges;
  final bool isPremium;
  final int currentStreak;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    this.email = '',
    this.name,
    this.bio,
    this.avatarUrl,
    this.xp = 0,
    this.level = 1,
    this.badges = const [],
    this.isPremium = false,
    this.currentStreak = 0,
    this.createdAt,
  });

  /// Créer un UserModel à partir des données JSON de Supabase
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parser les badges depuis JSONB
    List<String> parsedBadges = [];
    if (json['badges'] != null) {
      if (json['badges'] is List) {
        parsedBadges =
            (json['badges'] as List).map((e) => e.toString()).toList();
      }
    }

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      xp: json['xp'] as int? ?? json['total_points'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      badges: parsedBadges,
      isPremium: json['is_premium'] as bool? ?? false,
      currentStreak: json['current_streak'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convertir le UserModel en JSON pour l'envoyer à Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'bio': bio,
      'avatar_url': avatarUrl,
      'xp': xp,
      'level': level,
      'badges': badges,
      'is_premium': isPremium,
      'current_streak': currentStreak,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  /// Progression vers le niveau suivant (0.0 à 1.0)
  double get progressToNextLevel {
    final xpForCurrentLevel = (level - 1) * 100;
    final xpForNextLevel = level * 100;
    final xpInCurrentLevel = xp - xpForCurrentLevel;
    final xpNeededForLevel = xpForNextLevel - xpForCurrentLevel;
    return (xpInCurrentLevel / xpNeededForLevel).clamp(0.0, 1.0);
  }

  /// XP restants pour atteindre le niveau suivant
  int get xpToNextLevel {
    final xpForNextLevel = level * 100;
    return xpForNextLevel - xp;
  }

  /// L'utilisateur est-il authentifié ? (a un email)
  bool get isAuthenticated => email.isNotEmpty;

  /// Créer une copie du UserModel avec des modifications
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? bio,
    String? avatarUrl,
    int? xp,
    int? level,
    List<String>? badges,
    bool? isPremium,
    int? currentStreak,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      isPremium: isPremium ?? this.isPremium,
      currentStreak: currentStreak ?? this.currentStreak,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Alias de compatibilité pour le code profil existant
typedef UserProfile = UserModel;

/// Représente un badge déblocable dans l'application
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

/// Condition pour débloquer un badge
class BadgeCondition {
  final String type;
  final dynamic value;

  BadgeCondition({required this.type, this.value});
}

/// Liste de tous les badges disponibles dans l'application
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
