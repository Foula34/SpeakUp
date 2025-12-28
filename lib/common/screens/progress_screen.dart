import 'package:flutter/material.dart';

/// Écran temporaire de progrès (en attendant l'implémentation complète)
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101622) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF101622) : const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Progrès',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF212529),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 80,
              color: const Color(0xFF3E92CC).withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Écran de Progrès',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'En cours de développement',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF6C757D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
