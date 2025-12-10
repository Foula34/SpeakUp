import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/review_session_provider.dart';
import '../providers/recording_provider.dart';

/// Écran 4 : Revue de la Session d'Enregistrement
/// Affiche les statistiques et permet d'écouter l'enregistrement
class ReviewSessionScreen extends ConsumerStatefulWidget {
  const ReviewSessionScreen({super.key});

  @override
  ConsumerState<ReviewSessionScreen> createState() =>
      _ReviewSessionScreenState();
}

class _ReviewSessionScreenState extends ConsumerState<ReviewSessionScreen> {
  @override
  void initState() {
    super.initState();
    // Initialiser l'écran avec les données de l'enregistrement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recordingState = ref.read(recordingProvider);
      if (recordingState.recordingPath != null) {
        ref.read(reviewSessionProvider.notifier).initialize(
              audioPath: recordingState.recordingPath!,
              durationInSeconds: recordingState.currentDuration,
              challengeTitle: recordingState.challengeTitle,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewSessionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8),
      body: SafeArea(
        child: Column(
          children: [
            // TopAppBar
            _buildTopAppBar(context, isDark),

            // Contenu avec scroll
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Lecteur Audio
                          _buildAudioPlayer(state, isDark),

                          // Statistiques
                          _buildStatistics(state, isDark),

                          // Conseils
                          _buildAdviceCard(state, isDark),

                          const SizedBox(height: 100), // Espace pour les boutons
                        ],
                      ),
                    ),
            ),

            // Boutons d'action en bas
            _buildActionButtons(context, isDark),
          ],
        ),
      ),
    );
  }

  /// TopAppBar avec titre et boutons
  Widget _buildTopAppBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Bouton retour
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : const Color(0xFF212529),
              ),
            ),
          ),

          // Titre centré
          Expanded(
            child: Text(
              'Analyse de la Session',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF212529),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Bouton menu (optionnel)
          InkWell(
            onTap: () {
              // Menu optionnel
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: Icon(
                Icons.more_vert,
                color: isDark ? Colors.white : const Color(0xFF212529),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Lecteur audio avec contrôles
  Widget _buildAudioPlayer(ReviewSessionState state, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF101622),
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuASu01G5TkJihyxwcplxIZJsQlUK0nC1NyoFMpHI_TftuIGn1QrxPuQa4b95RqefDXJuR7Y_O_KOmD_4-LTRL0fmJIbKzG7vK3G14iZ0OFQ9az-iDOKQkC5GRNQHJYdJCWW8cBnPXtu1mDki4A4h6dzUxEui7UAC2syoJnjRyT8PngQAGH9zz-mpfHhLBMHewCpeytbxsmcPVhE51xEcDldJcsdJJdrrVeJV3SWkkEw3lJHc9zC0h8csp1ZV2mI2PtIQv1o4XfPLqoO',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            // Overlay sombre
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            // Bouton Play/Pause centré
            Center(
              child: InkWell(
                onTap: () {
                  ref.read(reviewSessionProvider.notifier).togglePlayPause();
                },
                borderRadius: BorderRadius.circular(32),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),

            // Barre de progression en bas
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Slider de progression
                    _buildProgressBar(state),

                    const SizedBox(height: 8),

                    // Temps actuel et durée totale
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(state.currentPosition),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          state.stats?.formattedDuration ?? '00:00',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Barre de progression personnalisée
  Widget _buildProgressBar(ReviewSessionState state) {
    final totalSeconds = state.stats?.durationInSeconds ?? 1;
    final currentSeconds = state.currentPosition.inSeconds;
    final progress = currentSeconds / totalSeconds;

    return Stack(
      children: [
        // Barre de fond
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Barre de progression
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          alignment: Alignment.centerLeft,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Curseur
        Positioned(
          left: (MediaQuery.of(context).size.width - 32) * progress.clamp(0.0, 1.0),
          top: -4,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  /// Section des statistiques
  Widget _buildStatistics(ReviewSessionState state, bool isDark) {
    if (state.stats == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            'Vos Statistiques',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF212529),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Carte des statistiques
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF101622) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStatItem(
                icon: Icons.timer,
                label: 'Durée',
                value: state.stats!.formattedDuration,
                isDark: isDark,
                isLast: false,
              ),
              _buildStatItem(
                icon: Icons.speed,
                label: 'Mots/Min',
                value: state.stats!.wordsPerMinute.toString(),
                isDark: isDark,
                isLast: false,
              ),
              _buildStatItem(
                icon: Icons.backspace,
                label: 'Mots de remplissage',
                value: state.stats!.fillerCount.toString(),
                isDark: isDark,
                isLast: false,
              ),
              _buildStatItem(
                icon: Icons.pause_circle,
                label: 'Pauses Longues',
                value: state.stats!.pauseCount.toString(),
                isDark: isDark,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Item individuel de statistique
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    required bool isLast,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  width: 1,
                ),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icône + Label
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF1152D4),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : const Color(0xFF6C757D),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // Valeur
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF212529),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Carte des conseils
  Widget _buildAdviceCard(ReviewSessionState state, bool isDark) {
    if (state.advice == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1152D4).withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône + Label
          Row(
            children: [
              const Icon(
                Icons.lightbulb,
                color: Color(0xFF1152D4),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Conseil du Jour',
                style: TextStyle(
                  color: const Color(0xFF1152D4),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Titre du conseil
          Text(
            state.advice!.title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF212529),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Description du conseil
          Text(
            state.advice!.description,
            style: TextStyle(
              color: isDark ? Colors.grey.shade300 : const Color(0xFF6C757D),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Boutons d'action en bas (sticky)
  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton "Sauvegarder dans le Journal"
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Sauvegarder dans le journal (table sessions)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session sauvegardée dans votre journal !'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1152D4).withOpacity(0.2),
                foregroundColor: const Color(0xFF1152D4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sauvegarder dans le Journal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Bouton "Publier dans la Communauté"
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigation vers l'écran de publication
                Navigator.pushNamed(context, '/publish');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1152D4),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Publier dans la Communauté',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formatte une durée en MM:SS
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
