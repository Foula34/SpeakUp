import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/recording_provider.dart';
import '../../../common/constants/app_colors.dart';

/// Écran d'enregistrement Premium (Caméra Pro UI)
class PracticeScreen extends ConsumerWidget {
  final String challengeTitle;

  const PracticeScreen({super.key, required this.challengeTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState = ref.watch(recordingProvider);
    final recordingNotifier = ref.read(recordingProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Camera View (Gradient/Blur background for MVP)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, AppColors.primary.withOpacity(0.3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context, challengeTitle),
                
                const Spacer(),
                
                // Timer
                _buildTimer(recordingState).animate(target: recordingState.isRecording ? 1 : 0)
                  .fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                
                const SizedBox(height: 40),
                
                // Bottom Controls Area (Glassmorphism Overlay)
                _buildBottomControls(context, recordingState, recordingNotifier),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => context.go('/home'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_outlined, color: Colors.white, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mock: Caméra retournée'), duration: Duration(seconds: 1)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(RecordingState state) {
    String formatDuration(int seconds) {
      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: state.isRecording ? AppColors.recordButton : Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.isRecording)
            Container(
              width: 12, height: 12,
              margin: const EdgeInsets.only(right: 12),
              decoration: const BoxDecoration(color: AppColors.recordButton, shape: BoxShape.circle),
            ).animate(onPlay: (c) => c.repeat()).fadeOut(duration: 1.seconds),
          Text(
            '${formatDuration(state.currentDuration)} / ${formatDuration(state.maxDuration)}',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, RecordingState state, RecordingNotifier notifier) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: const Border(top: BorderSide(color: Colors.white10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Settings rows (Duration & Ambiance) faded out while recording
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: state.isRecording ? 0.3 : 1.0,
                child: Column(
                  children: [
                    _buildSettingsRow(
                      icon: Icons.timer_outlined,
                      options: [
                        _buildOptionButton('30s', state.maxDuration == 30, () => notifier.setDuration(30), state.isRecording),
                        _buildOptionButton('1 min', state.maxDuration == 60, () => notifier.setDuration(60), state.isRecording),
                        _buildOptionButton('2 min', state.maxDuration == 120, () => notifier.setDuration(120), state.isRecording),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSettingsRow(
                      icon: Icons.surround_sound_outlined,
                      options: [
                        _buildOptionButton('Silence', state.selectedAmbiance == 'Silencieux', () => notifier.setAmbiance('Silencieux'), state.isRecording),
                        _buildOptionButton('Salle', state.selectedAmbiance == 'Salle', () => notifier.setAmbiance('Salle'), state.isRecording),
                        _buildOptionButton('Public', state.selectedAmbiance == 'Auditorium', () => notifier.setAmbiance('Auditorium'), state.isRecording),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // REC Button Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mock: Galerie ouverte'), duration: Duration(seconds: 1))),
                    child: const CircleAvatar(backgroundColor: Colors.white10, radius: 24, child: Icon(Icons.photo_library_outlined, color: Colors.white)),
                  ),
                  
                  // Main REC
                  _buildRecordButton(state, notifier, context),
                  
                  // Filters/Effects
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mock: Filtres affichés'), duration: Duration(seconds: 1))),
                    child: const CircleAvatar(backgroundColor: Colors.white10, radius: 24, child: Icon(Icons.auto_awesome, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow({required IconData icon, required List<Widget> options}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 24),
        const SizedBox(width: 16),
        Expanded(child: Row(children: options)),
      ],
    );
  }

  Widget _buildOptionButton(String label, bool isSelected, VoidCallback onTap, bool isDisabled) {
    return Expanded(
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.white24),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordButton(RecordingState state, RecordingNotifier notifier, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await notifier.toggleRecording(challengeTitle);
        if (!state.isRecording && state.recordingPath != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.push('/review', extra: {'recordingPath': state.recordingPath, 'challengeTitle': challengeTitle, 'duration': state.currentDuration});
            }
          });
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse Ring Effect
          if (state.isRecording)
            Container(
              width: 110, height: 110,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.recordButton, width: 2)),
            ).animate(onPlay: (c) => c.repeat()).scaleXY(begin: 1.0, end: 1.5).fadeOut(duration: 1.seconds),

          // Outer Ring
          Container(
            width: 86, height: 86,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
            child: Center(
              // Inner REC shape
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                width: state.isRecording ? 36 : 70,
                height: state.isRecording ? 36 : 70,
                decoration: BoxDecoration(color: AppColors.recordButton, borderRadius: BorderRadius.circular(state.isRecording ? 10 : 35)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
