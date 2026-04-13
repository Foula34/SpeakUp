import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/review_session_provider.dart';
import '../providers/recording_provider.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/glass_card.dart';
import '../../../common/widgets/gradient_button.dart';

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
        ref
            .read(reviewSessionProvider.notifier)
            .initialize(
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
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Gradient (Ambiance)
          Positioned(
            top: 100, left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.15)),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 1.0, end: 1.2, duration: 4.seconds),
          
          SafeArea(
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

                          const SizedBox(
                            height: 100,
                          ), // Espace pour les boutons
                        ],
                      ),
                    ),
            ),

            // Boutons d'action en bas
            _buildActionButtons(context, isDark).animate().slideY(begin: 1.0, end: 0, duration: 500.ms, curve: Curves.easeOutCubic),
          ],
        ),
      ),
      ],
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
            onTap: () => context.go('/home'),
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
                color: Colors.black.withValues(alpha: 0.3),
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
                    color: Colors.black.withValues(alpha: 0.4),
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
            color: Colors.white.withValues(alpha: 0.4),
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
          left:
              (MediaQuery.of(context).size.width - 32) *
              progress.clamp(0.0, 1.0),
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
          child: const Text(
            'Vos Statistiques',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        // Carte des statistiques
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStatItem(icon: Icons.timer, label: 'Durée', value: state.stats!.formattedDuration, isLast: false),
              _buildStatItem(icon: Icons.speed, label: 'Mots/Min', value: state.stats!.wordsPerMinute.toString(), isLast: false),
              _buildStatItem(icon: Icons.backspace, label: 'Mots de remplissage', value: state.stats!.fillerCount.toString(), isLast: false),
              _buildStatItem(icon: Icons.pause_circle, label: 'Pauses Longues', value: state.stats!.pauseCount.toString(), isLast: true),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }

  /// Item individuel de statistique
  Widget _buildStatItem({required IconData icon, required String label, required String value, required bool isLast}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Carte des conseils
  Widget _buildAdviceCard(ReviewSessionState state, bool isDark) {
    if (state.advice == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.orangeAccent, size: 20),
              SizedBox(width: 8),
              Text('Conseil du Jour', style: TextStyle(color: Colors.orangeAccent, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(state.advice!.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(state.advice!.description, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  /// Boutons d'action en bas (sticky)
  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.9),
        border: const Border(top: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientButton(
            text: 'Publier dans la Communauté',
            icon: Icons.rocket_launch,
            onPressed: () {
              context.push('/publish');
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Session sauvegardée dans votre journal !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.go('/home');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.accent.withOpacity(0.5), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Sauvegarder dans le Journal', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
