import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speakup_mvp/core/providers/auth_provider.dart';
import '../common/constants/app_colors.dart';
import '../common/constants/app_routes.dart';
import '../common/screens/main_navigation_screen.dart';
import '../features/auth/presentation/auth_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/community/presentation/community_feed_screen.dart';
import '../features/community/presentation/publish_screen.dart';
import '../features/community/presentation/comments_screen.dart';
import '../features/practice/presentation/practice_screen.dart';
import '../features/practice/presentation/review_session_screen.dart';
import '../features/profile/presentation/leaderboard_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

/// Configuration principale de l'application SpeakUp
///
/// ✅ Redirection automatique basée sur l'authentification
/// ✅ Protection des routes
/// ✅ Gestion du thème (clair + sombre)
/// ✅ Police Inter activée
class SpeakUpApp extends ConsumerWidget {
  const SpeakUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'SpeakUp',
      debugShowCheckedModeBanner: false,

      // ========== THÈME CLAIR ==========
      theme: _buildLightTheme(),

      // ========== THÈME SOMBRE ==========
      darkTheme: _buildDarkTheme(),

      // ========== MODE AUTOMATIQUE (suit le système) ==========
      themeMode: ThemeMode.dark,

      // ========== ROUTING ==========
      routerConfig: _createRouter(ref),
    );
  }

  /// Thème clair
  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      fontFamily: 'Inter',

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
    );
  }

  /// Thème sombre
  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: 'Inter',

      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
    );
  }
}

/// Créer le router avec redirection automatique
GoRouter _createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,

    // ========== REDIRECTION AUTOMATIQUE ==========
    redirect: (context, state) {
      // Récupérer l'état d'authentification
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;

      // Pages publiques (accessibles sans connexion)
      final publicRoutes = [AppRoutes.login, AppRoutes.resetPassword];
      final isOnPublicRoute = publicRoutes.contains(state.matchedLocation);

      // Si l'app charge l'état initial, ne rien faire
      if (isLoading) {
        return null;
      }

      // Si l'utilisateur n'est PAS connecté et essaie d'accéder à une page privée
      if (!isAuthenticated && !isOnPublicRoute) {
        return AppRoutes.login;
      }

      // Si l'utilisateur EST connecté et essaie d'accéder à login/signup
      if (isAuthenticated && isOnPublicRoute) {
        return AppRoutes.home;
      }

      // Laisser passer
      return null;
    },

    // ========== RAFRAÎCHIR QUAND L'AUTH CHANGE ==========
    refreshListenable: _AuthChangeNotifier(ref),

    routes: [
      // ========== AUTHENTIFICATION ==========
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ========== NAVIGATION PRINCIPALE ==========
      // La route /home gère les 4 onglets via MainNavigationScreen
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainNavigationScreen(initialTab: 0),
      ),

      // ========== PRATIQUE (écran dédié, hors bottom nav) ==========
      GoRoute(
        path: AppRoutes.practice,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final challengeTitle =
              extra?['challengeTitle'] as String? ??
              'Présenter son projet en 2 minutes';

          return PracticeScreen(challengeTitle: challengeTitle);
        },
      ),

      // Route pour l'écran de review après enregistrement
      GoRoute(
        path: '/review',
        builder: (context, state) => const ReviewSessionScreen(),
      ),

      // ========== COMMUNITY (Communauté) ==========
      GoRoute(
        path: AppRoutes.feed,
        builder: (context, state) => const CommunityFeedScreen(),
      ),
      GoRoute(
        path: AppRoutes.publish,
        builder: (context, state) => const PublishScreen(),
      ),
      GoRoute(
        path: AppRoutes.comments,
        builder: (context, state) => const CommentsScreen(),
      ),

      // ========== PROFILE & SETTINGS ==========
      GoRoute(
        path: AppRoutes.leaderboard,
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    // ========== PAGE D'ERREUR ==========
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Notifier pour rafraîchir le router quand l'auth change
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated) {
        notifyListeners();
      }
    });
  }
}
