import 'package:flutter/material.dart';

/// Bottom Navigation Bar de l'application SpeakUp
/// 4 onglets : Accueil, Pratique, Progrès, Profil
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2D7A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF0A2463) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Accueil',
                isDark: isDark,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.mic_none,
                selectedIcon: Icons.mic,
                label: 'Pratique',
                isDark: isDark,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.bar_chart_outlined,
                selectedIcon: Icons.bar_chart,
                label: 'Progrès',
                isDark: isDark,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profil',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected 
        ? const Color(0xFF3E92CC) // Accent color
        : isDark 
            ? const Color(0xFFB0B8C4) // Text secondary dark
            : const Color(0xFF71717A); // Text secondary light

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: color,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
