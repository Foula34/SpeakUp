import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speakup_mvp/core/providers/auth_provider.dart';
import '../common/constants/app_colors.dart';
import '../common/constants/app_routes.dart';
import '../features/auth/presentation/auth_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/practice/presentation/practice_screen.dart';
import '../features/practice/presentation/review_session_screen.dart';

/// Configuration principale de l'application SpeakUp
///
/// ✅ Redirection automatique basée sur l'authentification
/// ✅ Protection des routes
/// ✅ Gestion du thème
class SpeakUpApp extends ConsumerWidget {
  const SpeakUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'SpeakUp',
      debugShowCheckedModeBanner: false,

      // ========== THÈME ==========
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceLight,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          centerTitle: false,
        ),

        // TODO: Ajouter la police Inter dans assets/fonts/
        // fontFamily: 'Inter',
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
          selectedItemColor: AppColors.primary,
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
      ),

      // ========== ROUTING ==========
      routerConfig: _createRouter(ref),
    );
  }
}

/// Créer le router avec redirection automatique
GoRouter _createRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,

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
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // ========== PRATIQUE ==========
      GoRoute(
        path: '/practice',
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

      // TODO: Ajouter les autres routes
      // GoRoute(
      //   path: AppRoutes.feed,
      //   builder: (context, state) => const CommunityFeedScreen(),
      // ),
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
