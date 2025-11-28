import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/recording_provider.dart';

/// Écran d'enregistrement (Écran 3 du cahier des charges)
/// Permet d'enregistrer sa voix avec un timer et des ambiances
class PracticeScreen extends ConsumerWidget {
  final String challengeTitle;
  
  const PracticeScreen({
    super.key,
    required this.challengeTitle,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer l'état depuis le provider
    final recordingState = ref.watch(recordingProvider);
    final recordingNotifier = ref.read(recordingProvider.notifier);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      
      // Barre du haut
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Enregistrement',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Menu d'options (à implémenter plus tard)
            },
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Titre du défi
              Text(
              challengeTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Timer (affichage du temps)
              _buildTimer(recordingState),
              
              const SizedBox(height: 60),
              
              // Section Durée
              const Text(
              'Durée',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              ),
              const SizedBox(height: 16),
              _buildDurationSelector(recordingState, recordingNotifier),
              
              const SizedBox(height: 40),
              
              // Section Ambiance
              const Text(
              'Ambiance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              ),
              const SizedBox(height: 16),
              _buildAmbianceSelector(recordingState, recordingNotifier),
              
              const SizedBox(height: 60),
              
              // Gros bouton REC
              _buildRecordButton(
              recordingState,
              recordingNotifier,
              context,
            ),
            
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Widget qui affiche le timer (00:00 / 02:00)
  Widget _buildTimer(RecordingState state) {
    // Convertir les secondes en format MM:SS
    String formatDuration(int seconds) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        '${formatDuration(state.currentDuration)} / ${formatDuration(state.maxDuration)}',
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1,
        ),
      ),
    );
  }
  
  /// Widget qui affiche les boutons de durée (30s, 1min, 2min)
  Widget _buildDurationSelector(
    RecordingState state,
    RecordingNotifier notifier,
  ) {
    return Row(
      children: [
        _buildDurationButton('30s', 30, state, notifier),
        const SizedBox(width: 12),
        _buildDurationButton('1 min', 60, state, notifier),
        const SizedBox(width: 12),
        _buildDurationButton('2 min', 120, state, notifier),
      ],
    );
  }
  
  /// Bouton individuel de durée
  Widget _buildDurationButton(
    String label,
    int seconds,
    RecordingState state,
    RecordingNotifier notifier,
  ) {
    final isSelected = state.maxDuration == seconds;
    final isDisabled = state.isRecording;
    
    return Expanded(
      child: GestureDetector(
        onTap: isDisabled ? null : () => notifier.setDuration(seconds),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isDisabled ? Colors.grey : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
  
  /// Widget qui affiche les boutons d'ambiance
  Widget _buildAmbianceSelector(
    RecordingState state,
    RecordingNotifier notifier,
  ) {
    return Row(
      children: [
        _buildAmbianceButton('Silencieux', state, notifier),
        const SizedBox(width: 12),
        _buildAmbianceButton('Salle', state, notifier),
        const SizedBox(width: 12),
        _buildAmbianceButton('Auditorium', state, notifier),
      ],
    );
  }
  
  /// Bouton individuel d'ambiance
  Widget _buildAmbianceButton(
    String label,
    RecordingState state,
    RecordingNotifier notifier,
  ) {
    final isSelected = state.selectedAmbiance == label;
    final isDisabled = state.isRecording;
    
    return Expanded(
      child: GestureDetector(
        onTap: isDisabled ? null : () => notifier.setAmbiance(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isDisabled ? Colors.grey : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
  
  /// Le gros bouton REC/STOP en bas
  Widget _buildRecordButton(
    RecordingState state,
    RecordingNotifier notifier,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () async {
        await notifier.toggleRecording(challengeTitle);
        
        // Si l'enregistrement vient de s'arrêter, aller à l'écran de revue
        if (!state.isRecording && state.recordingPath != null) {
          // Attendre un peu pour que l'état se mette à jour
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.push(
                '/review',
                extra: {
                  'recordingPath': state.recordingPath,
                  'challengeTitle': challengeTitle,
                  'duration': state.currentDuration,
                },
              );
            }
          });
        }
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: state.isRecording ? Colors.grey[700] : Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            state.isRecording ? 'STOP' : 'REC',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
