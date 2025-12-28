import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

/// Provider qui gère l'état du profil utilisateur
class ProfileNotifier extends StateNotifier<ProfileState> {
  final SupabaseClient _supabase;

  ProfileNotifier(this._supabase) : super(ProfileState.initial());

  /// Charger le profil de l'utilisateur connecté
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      final user = UserProfile.fromJson(response);

      final sessionsResponse = await _supabase
          .from('sessions')
          .select('id')
          .eq('user_id', userId);

      final sessionCount = (sessionsResponse as List).length;

      final postsResponse = await _supabase
          .from('posts')
          .select('id')
          .eq('user_id', userId);

      final postCount = (postsResponse as List).length;

      state = state.copyWith(
        isLoading: false,
        user: user,
        sessionCount: sessionCount,
        postCount: postCount,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Erreur lors du chargement du profil: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateProfile({
    String? name,
    String? bio,
    String? avatarUrl,
  }) async {
    if (state.user == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final userId = state.user!.id;

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _supabase.from('users').update(updates).eq('id', userId);

      final updatedUser = state.user!.copyWith(
        name: name,
        bio: bio,
        avatarUrl: avatarUrl,
      );

      state = state.copyWith(
        isLoading: false,
        user: updatedUser,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Erreur lors de la mise à jour du profil: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addXP(int xpToAdd) async {
    if (state.user == null) return;

    final currentXP = state.user!.xp;
    final newXP = currentXP + xpToAdd;

    final newLevel = (newXP / 100).floor() + 1;

    try {
      await _supabase.from('users').update({
        'xp': newXP,
        'level': newLevel,
      }).eq('id', state.user!.id);

      final updatedUser = state.user!.copyWith(
        xp: newXP,
        level: newLevel,
      );

      state = state.copyWith(user: updatedUser);
    } catch (e) {
      // ignore: avoid_print
      print('Erreur lors de l\'ajout d\'XP: $e');
    }
  }

  Future<void> unlockBadge(String badgeId) async {
    if (state.user == null) return;

    if (state.user!.badges.contains(badgeId)) return;

    try {
      final newBadges = [...state.user!.badges, badgeId];

      await _supabase.from('users').update({
        'badges': newBadges,
      }).eq('id', state.user!.id);

      final updatedUser = state.user!.copyWith(badges: newBadges);

      state = state.copyWith(user: updatedUser);
    } catch (e) {
      // ignore: avoid_print
      print('Erreur lors du déverrouillage du badge: $e');
    }
  }
}

class ProfileState {
  final bool isLoading;
  final UserProfile? user;
  final int sessionCount;
  final int postCount;
  final String? error;

  ProfileState({
    required this.isLoading,
    this.user,
    this.sessionCount = 0,
    this.postCount = 0,
    this.error,
  });

  factory ProfileState.initial() {
    return ProfileState(isLoading: false);
  }

  ProfileState copyWith({
    bool? isLoading,
    UserProfile? user,
    int? sessionCount,
    int? postCount,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      sessionCount: sessionCount ?? this.sessionCount,
      postCount: postCount ?? this.postCount,
      error: error ?? this.error,
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final supabase = Supabase.instance.client;
  return ProfileNotifier(supabase);
});