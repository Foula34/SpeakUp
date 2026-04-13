import 'package:flutter/material.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../widgets/navigation/bottom_nav_bar.dart';
import 'practice_main_screen.dart';
import 'progress_screen.dart';

/// Écran principal qui gère la navigation avec la BottomNavBar
///
/// Utilise [IndexedStack] pour préserver l'état de chaque onglet.
/// Le paramètre [initialTab] permet de démarrer sur un onglet spécifique.
class MainNavigationScreen extends StatefulWidget {
  final int initialTab;

  const MainNavigationScreen({super.key, this.initialTab = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  // Liste des écrans correspondant aux onglets
  final List<Widget> _screens = const [
    HomeScreen(), // 0: Accueil
    PracticeMainScreen(), // 1: Pratique
    ProgressScreen(), // 2: Progrès
    ProfileScreen(), // 3: Profil
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
