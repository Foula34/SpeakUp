import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speakup_mvp/core/services/auth_service.dart';
import 'package:speakup_mvp/features/auth/models/user_model.dart';

/// État d'authentification de l'application
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  /// L'utilisateur est-il connecté ?
  bool get isAuthenticated => user != null;

  /// Créer une copie de l'état avec des modifications
  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// État initial (non connecté)
  factory AuthState.initial() {
    return const AuthState();
  }

  /// État de chargement
  factory AuthState.loading() {
    return const AuthState(isLoading: true);
  }

  /// État avec erreur
  factory AuthState.error(String message) {
    return AuthState(error: message);
  }

  /// État authentifié
  factory AuthState.authenticated(UserModel user) {
    return AuthState(user: user);
  }
}

/// Notifier qui gère l'état d'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial()) {
    // Charger l'utilisateur au démarrage si déjà connecté
    _checkInitialAuth();

    // Écouter les changements d'authentification
    _authService.authStateChanges.listen((user) {
      if (user == null) {
        state = AuthState.initial();
      } else {
        _loadCurrentUser();
      }
    });
  }

  /// Vérifier si un utilisateur est déjà connecté au démarrage
  Future<void> _checkInitialAuth() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      }
    } catch (e) {
      state = AuthState.initial();
    }
  }

  /// Charger les données complètes de l'utilisateur
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      }
    } catch (e) {
      state = AuthState.error('Erreur lors du chargement du profil');
    }
  }

  /// Connexion
  Future<void> signIn({required String email, required String password}) async {
    state = AuthState.loading();

    try {
      final user = await _authService.signIn(email: email, password: password);

      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Inscription
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = AuthState.loading();

    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = AuthState.initial();
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Effacer les erreurs
  void clearError() {
    if (state.error != null) {
      state = AuthState(user: state.user, isLoading: state.isLoading);
    }
  }
}

/// Provider principal de l'état d'authentification
///
/// Utilise ce provider partout dans l'app pour :
/// - Savoir si l'utilisateur est connecté : `ref.watch(authProvider).isAuthenticated`
/// - Accéder aux données utilisateur : `ref.watch(authProvider).user`
/// - Se connecter/déconnecter : `ref.read(authProvider.notifier).signIn(...)`
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});
