import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speakup_mvp/features/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service qui gère toutes les opérations d'authentification
///
/// Ce service est une couche au-dessus de Supabase Auth
/// pour simplifier les appels et gérer les erreurs
class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  /// Connexion avec email et mot de passe
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw Exception('Échec de la connexion');
      }

      // Récupérer les données complètes de l'utilisateur depuis la table 'users'
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userData);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erreur lors de la connexion: ${e.toString()}');
    }
  }

  /// Inscription avec email, mot de passe et nom
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1. Créer le compte dans Supabase Auth
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'name': name.trim()},
      );

      if (response.user == null) {
        throw Exception('Échec de l\'inscription');
      }

      // 2. Le profil est créé automatiquement par le trigger
      // Attendre un court instant pour que le trigger s'exécute
      await Future.delayed(const Duration(milliseconds: 500));

      // 3. Récupérer le profil créé
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userData);
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription: ${e.toString()}');
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Erreur lors de la déconnexion: ${e.toString()}');
    }
  }

  /// Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email.trim());
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Erreur lors de la réinitialisation: ${e.toString()}');
    }
  }

  /// Récupérer l'utilisateur actuel depuis la base de données
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        return null;
      }

      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  /// Stream qui écoute les changements d'état d'authentification
  Stream<User?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) => event.session?.user);
  }

  /// Gérer les erreurs d'authentification Supabase
  String _handleAuthException(AuthException e) {
    switch (e.message) {
      case 'Invalid login credentials':
        return 'Email ou mot de passe incorrect';
      case 'User already registered':
        return 'Cet email est déjà utilisé';
      case 'Email not confirmed':
        return 'Veuillez confirmer votre email';
      case 'Password should be at least 6 characters':
        return 'Le mot de passe doit contenir au moins 6 caractères';
      default:
        return e.message;
    }
  }
}

/// Provider du service d'authentification
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = Supabase.instance.client;
  return AuthService(supabase);
});
