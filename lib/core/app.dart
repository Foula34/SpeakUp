import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../common/constants/app_colors.dart';
import '../common/constants/app_routes.dart';
import '../features/auth/presentation/auth_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/practice/presentation/practice_screen.dart';

/// Configuration principale de l'application SpeakUp
///
/// Ce fichier configure :
/// - Le thème de l'application
/// - Le routing avec GoRouter
/// - L'état global avec Riverpod
class SpeakUpApp extends ConsumerWidget {
  const SpeakUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'SpeakUp',
      debugShowCheckedModeBanner: false,

      // ========== THÈME ==========
      theme: ThemeData(
        // Couleurs principales
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceLight,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          centerTitle: false,
        ),

        // Polices
        // TODO: Ajouter la police Inter dans assets/fonts/ et décommenter
        // fontFamily: 'Inter',

        // Champs de texte
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

        // Boutons
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

        // Bottom Navigation Bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // Cartes
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
      routerConfig: _router,
    );
  }
}

/// Configuration du routing avec GoRouter
///
/// TODO SUPABASE : Ajouter une logique de redirection basée sur l'authentification
/// - Si l'utilisateur est connecté → rediriger vers /home
/// - Si l'utilisateur n'est pas connecté → rediriger vers /login
final _router = GoRouter(
  initialLocation: '/practice', // 🎯 Pour tester l'écran d'enregistrement

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
    
    // ========== PRATIQUE (ENREGISTREMENT) ==========
    GoRoute(
      path: '/practice',
      builder: (context, state) {
        // Récupérer le titre du défi depuis les paramètres
        final extra = state.extra as Map<String, dynamic>?;
        final challengeTitle = extra?['challengeTitle'] as String? ?? 
            'Présenter son projet en 2 minutes';
        
        return PracticeScreen(challengeTitle: challengeTitle);
      },
    ),

    // TODO: Ajouter les autres routes au fur et à mesure
    // GoRoute(
    //   path: AppRoutes.feed,
    //   builder: (context, state) => const CommunityFeedScreen(),
    // ),
    // etc.
  ],

  // Page d'erreur (route non trouvée)
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
