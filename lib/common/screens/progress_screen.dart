import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Onglet 3 : Progrès (Historique des Sessions)
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Définir les limites de SafeArea en fonction de si on a une AppBar personnalisée ou non
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101622) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Mes Progrès',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Pas de bouton retour car c'est un onglet principal
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Résumé Statistique
            _buildStatSummaryRow(isDark),
            const SizedBox(height: 24),
            
            Text(
              'Historique des sessions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),
            
            // Liste des sessions d'entraînement (Mock)
            _buildSessionCard(
              title: 'Présenter son projet en 2 minutes',
              date: 'Aujourd\'hui, 10:30',
              score: 'A',
              duration: '01:58',
              wpm: 120,
              fillers: 2,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildSessionCard(
              title: 'Discours d\'équipe',
              date: 'Hier, 15:45',
              score: 'B+',
              duration: '03:15',
              wpm: 145,
              fillers: 5,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildSessionCard(
              title: 'Pitch investisseurs',
              date: 'Il y a 3 jours',
              score: 'C',
              duration: '04:30',
              wpm: 160,
              fillers: 12,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSummaryRow(bool isDark) {
    return Row(
      children: [
        Expanded(child: _buildStatBox('Sessions', '12', Icons.mic, AppColors.primary, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatBox('Temps total', '45m', Icons.timer, Colors.orange, isDark)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatBox('Moy WPM', '135', Icons.speed, Colors.green, isDark)),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color iconColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF71717A) : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard({
    required String title,
    required String date,
    required String score,
    required String duration,
    required int wpm,
    required int fillers,
    required bool isDark,
  }) {
    Color scoreColor;
    if (score.startsWith('A')) scoreColor = Colors.green;
    else if (score.startsWith('B')) scoreColor = Colors.orange;
    else scoreColor = Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF71717A) : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Note Globale
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  score,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: scoreColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Sub-stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSubStat(Icons.timer, duration, 'Durée', isDark),
              _buildSubStat(Icons.speed, '$wpm', 'Mots/m', isDark),
              _buildSubStat(Icons.mic_off, '$fillers', 'Fillers', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubStat(IconData icon, String value, String label, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? const Color(0xFF71717A) : AppColors.textSecondaryLight),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? const Color(0xFF71717A) : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
