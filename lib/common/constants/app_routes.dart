/// Classe contenant toutes les routes de l'application
/// Utilisées avec GoRouter pour la navigation
class AppRoutes {
  // Empêcher l'instanciation
  AppRoutes._();

  // ========== AUTHENTIFICATION ==========
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPassword = '/reset-password';
  
  // ========== NAVIGATION PRINCIPALE ==========
  static const String home = '/home';
  static const String feed = '/feed';
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  // ========== PRACTICE (Entraînement) ==========
  static const String practice = '/practice';
  static const String reviewSession = '/review-session';
  static const String progressLog = '/progress-log';
  
  // ========== COMMUNITY (Communauté) ==========
  static const String publish = '/publish';
  static const String postDetail = '/post-detail';
  static const String comments = '/comments';
  static const String leaderboard = '/leaderboard';
  static const String report = '/report';
  static const String search = '/search';
  
  // ========== PROFILE & SETTINGS ==========
  static const String editProfile = '/edit-profile';
  static const String userProfile = '/user-profile'; // Profil d'un autre utilisateur
  static const String notifications = '/notifications';
  static const String notificationPreferences = '/notification-preferences';
  static const String help = '/help';
  static const String about = '/about';
}
