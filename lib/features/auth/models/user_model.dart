/// Modèle représentant un utilisateur de l'application
///
/// Correspond à la table 'users' dans Supabase
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? bio;
  final String? avatarUrl;
  final int level;
  final int totalPoints; // Alias de 'xp' dans la DB
  final List<String> badges;
  final bool isPremium;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.bio,
    this.avatarUrl,
    this.level = 1,
    this.totalPoints = 0,
    this.badges = const [],
    this.isPremium = false,
    required this.createdAt,
  });

  /// Créer un UserModel à partir des données JSON de Supabase
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parser les badges depuis JSONB
    List<String> parsedBadges = [];
    if (json['badges'] != null) {
      if (json['badges'] is List) {
        parsedBadges = (json['badges'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      level: json['level'] as int? ?? 1,
      totalPoints: json['total_points'] as int? ?? 0,
      badges: parsedBadges,
      isPremium: json['is_premium'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
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
      'level': level,
      'total_points': totalPoints,
      'badges': badges,
      'is_premium': isPremium,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Créer une copie du UserModel avec des modifications
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? bio,
    String? avatarUrl,
    int? level,
    int? totalPoints,
    List<String>? badges,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      totalPoints: totalPoints ?? this.totalPoints,
      badges: badges ?? this.badges,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
