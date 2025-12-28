import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../common/constants/app_routes.dart';
import '../widgets/navigation/bottom_nav_bar.dart';
import 'practice_main_screen.dart';
import 'progress_screen.dart';

/// Écran principal qui gère la navigation avec la BottomNavBar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Obtenir l'index courant basé sur la route actuelle
  int _getCurrentIndex(String location) {
    if (location.startsWith('/progress')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // Accueil par défaut
  }

  // Liste des écrans correspondant aux onglets
  final List<Widget> _screens = const [
    HomeScreen(), // 0: Accueil
    PracticeMainScreen(), // 1: Pratique
    ProgressScreen(), // 2: Progrès
    ProfileScreen(), // 3: Profil
  ];

  void _onTabTapped(int index) {
    // Navigation avec GoRouter en fonction de l'index
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go('/practice');
        break;
      case 2:
        context.go('/progress');
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
      default:
        context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la route actuelle depuis GoRouter
    final currentLocation = GoRouterState.of(context).uri.toString();
    final currentIndex = _getCurrentIndex(currentLocation);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
