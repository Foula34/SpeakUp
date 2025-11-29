import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/recording_service.dart';

/// Le "cerveau" de l'écran d'enregistrement
/// Il gère tout : le timer, les boutons, l'état de l'enregistrement
class RecordingNotifier extends StateNotifier<RecordingState> {
  final RecordingService _recordingService;
  Timer? _timer;
  
  RecordingNotifier(this._recordingService) 
      : super(RecordingState.initial());
  
  /// Change la durée sélectionnée (30s, 1min, 2min)
  void setDuration(int seconds) {
    // On ne peut pas changer la durée pendant l'enregistrement
    if (state.isRecording) return;
    
    state = state.copyWith(
      maxDuration: seconds,
      currentDuration: 0, // Remettre le timer à 0
    );
  }
  
  /// Change l'ambiance sélectionnée
  void setAmbiance(String ambiance) {
    // On ne peut pas changer l'ambiance pendant l'enregistrement
    if (state.isRecording) return;
    
    state = state.copyWith(selectedAmbiance: ambiance);
  }
  
  /// Démarre ou arrête l'enregistrement
  Future<void> toggleRecording(String challengeTitle) async {
    if (state.isRecording) {
      // Arrêter l'enregistrement
      await _stopRecording();
    } else {
      // Démarrer l'enregistrement
      await _startRecording(challengeTitle);
    }
  }
  
  /// Démarre l'enregistrement
  Future<void> _startRecording(String challengeTitle) async {
    // Remettre le timer à 0 et démarrer immédiatement
    state = state.copyWith(
      currentDuration: 0,
      challengeTitle: challengeTitle,
      isRecording: true, // Démarrer tout de suite pour lancer le timer
    );
    
    // Démarrer le timer immédiatement (se met à jour chaque seconde)
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newDuration = state.currentDuration + 1;
      
      // Vérifier si on a atteint la limite de temps
      if (newDuration >= state.maxDuration) {
        _stopRecording(); // Arrêter automatiquement
      } else {
        state = state.copyWith(currentDuration: newDuration);
      }
    });
    
    // Démarrer le service d'enregistrement en parallèle
    final path = await _recordingService.startRecording(
      ambianceSound: state.selectedAmbiance,
    );
    
    if (path != null) {
      // Mettre à jour le chemin d'enregistrement
      state = state.copyWith(recordingPath: path);
    }
  }
  
  /// Arrête l'enregistrement
  Future<void> _stopRecording() async {
    // Arrêter le timer
    _timer?.cancel();
    _timer = null;
    
    // Arrêter le service d'enregistrement
    final path = await _recordingService.stopRecording();
    
    state = state.copyWith(
      isRecording: false,
      recordingPath: path,
    );
  }
  
  /// Nettoyer quand on quitte l'écran
  @override
  void dispose() {
    _timer?.cancel();
    _recordingService.dispose();
    super.dispose();
  }
}

/// La classe qui représente l'état de l'écran d'enregistrement
/// C'est comme une "photo" de l'écran à un instant T
class RecordingState {
  final bool isRecording; // Est-ce qu'on enregistre ?
  final int currentDuration; // Temps écoulé en secondes
  final int maxDuration; // Temps maximum en secondes
  final String selectedAmbiance; // Ambiance sélectionnée
  final String? recordingPath; // Chemin du fichier enregistré
  final String challengeTitle; // Titre du défi
  
  RecordingState({
    required this.isRecording,
    required this.currentDuration,
    required this.maxDuration,
    required this.selectedAmbiance,
    this.recordingPath,
    this.challengeTitle = '',
  });
  
  /// État initial (quand on arrive sur l'écran)
  factory RecordingState.initial() {
    return RecordingState(
      isRecording: false,
      currentDuration: 0,
      maxDuration: 120, // 2 minutes par défaut
      selectedAmbiance: 'Silencieux',
    );
  }
  
  /// Créer une copie avec certaines valeurs modifiées
  RecordingState copyWith({
    bool? isRecording,
    int? currentDuration,
    int? maxDuration,
    String? selectedAmbiance,
    String? recordingPath,
    String? challengeTitle,
  }) {
    return RecordingState(
      isRecording: isRecording ?? this.isRecording,
      currentDuration: currentDuration ?? this.currentDuration,
      maxDuration: maxDuration ?? this.maxDuration,
      selectedAmbiance: selectedAmbiance ?? this.selectedAmbiance,
      recordingPath: recordingPath ?? this.recordingPath,
      challengeTitle: challengeTitle ?? this.challengeTitle,
    );
  }
}

/// Provider qui fournit le RecordingNotifier à toute l'application
final recordingProvider = StateNotifierProvider<RecordingNotifier, RecordingState>((ref) {
  return RecordingNotifier(RecordingService());
});
