import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../services/stats_analyzer_service.dart';

/// Provider qui gère l'état de l'écran de revue (Review Session)
class ReviewSessionNotifier extends StateNotifier<ReviewSessionState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final StatsAnalyzerService _statsAnalyzer = StatsAnalyzerService();

  ReviewSessionNotifier() : super(ReviewSessionState.initial());

  /// Initialise l'écran de revue avec les données de la session
  Future<void> initialize({
    required String audioPath,
    required int durationInSeconds,
    required String challengeTitle,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // Charger le fichier audio dans le lecteur
      // Utiliser FileSource pour les fichiers locaux
      await _audioPlayer.setAudioSource(AudioSource.file(audioPath));

      // Analyser les statistiques
      final stats = await _statsAnalyzer.analyzeRecording(
        audioPath: audioPath,
        durationInSeconds: durationInSeconds,
      );

      // Générer les conseils
      final advice = _statsAnalyzer.generateAdvice(stats);

      // Mettre à jour l'état
      state = state.copyWith(
        isLoading: false,
        audioPath: audioPath,
        challengeTitle: challengeTitle,
        stats: stats,
        advice: advice,
      );

      // Écouter les changements de position du lecteur
      _audioPlayer.positionStream.listen((position) {
        state = state.copyWith(currentPosition: position);
      });

      // Écouter les changements d'état du lecteur
      _audioPlayer.playerStateStream.listen((playerState) {
        state = state.copyWith(
          isPlaying: playerState.playing,
        );
      });
    } catch (e) {
      print('Erreur lors de l\'initialisation: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Jouer ou mettre en pause l'audio
  Future<void> togglePlayPause() async {    if (state.isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  /// Aller à une position spécifique dans l'audio
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Obtenir la durée totale de l'audio
  Duration? get totalDuration => _audioPlayer.duration;

  /// Nettoyer les ressources
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

/// État de l'écran de revue
class ReviewSessionState {
  final bool isLoading;
  final bool isPlaying;
  final String? audioPath;
  final String challengeTitle;
  final SessionStats? stats;
  final SessionAdvice? advice;
  final Duration currentPosition;
  final String? error;

  ReviewSessionState({
    required this.isLoading,
    required this.isPlaying,
    this.audioPath,
    this.challengeTitle = '',
    this.stats,
    this.advice,
    this.currentPosition = Duration.zero,
    this.error,
  });

  factory ReviewSessionState.initial() {
    return ReviewSessionState(
      isLoading: false,
      isPlaying: false,
    );
  }

  ReviewSessionState copyWith({
    bool? isLoading,
    bool? isPlaying,
    String? audioPath,
    String? challengeTitle,
    SessionStats? stats,
    SessionAdvice? advice,
    Duration? currentPosition,
    String? error,
  }) {
    return ReviewSessionState(
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      audioPath: audioPath ?? this.audioPath,
      challengeTitle: challengeTitle ?? this.challengeTitle,
      stats: stats ?? this.stats,
      advice: advice ?? this.advice,
      currentPosition: currentPosition ?? this.currentPosition,
      error: error ?? this.error,
    );
  }
}

/// Provider global
final reviewSessionProvider =
    StateNotifierProvider<ReviewSessionNotifier, ReviewSessionState>((ref) {
  return ReviewSessionNotifier();
});
