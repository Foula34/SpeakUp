import 'dart:async';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

/// Service qui gère l'enregistrement audio/vidéo
/// C'est comme un "assistant" qui s'occupe de toute la partie technique
class RecordingService {
  // L'objet qui enregistre l'audio
  final AudioRecorder _audioRecorder = AudioRecorder();
  
  // L'objet qui joue les sons d'ambiance
  final AudioPlayer _ambiancePlayer = AudioPlayer();
  
  // Indique si on est en train d'enregistrer
  bool _isRecording = false;
  
  // Le chemin où le fichier audio est sauvegardé
  String? _recordingPath;
  
  // Getters (pour lire les valeurs depuis l'extérieur)
  bool get isRecording => _isRecording;
  String? get recordingPath => _recordingPath;
  
  /// Démarre l'enregistrement audio
  /// Retourne le chemin du fichier ou null si erreur
  Future<String?> startRecording({String? ambianceSound}) async {
    try {
      // Vérifier si on a la permission d'enregistrer
      if (await _audioRecorder.hasPermission()) {
        // Créer le dossier où sauvegarder l'enregistrement
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        _recordingPath = '${directory.path}/recording_$timestamp.m4a';
        
        // Jouer le son d'ambiance si demandé
        if (ambianceSound != null && ambianceSound != 'Silencieux') {
          await _playAmbianceSound(ambianceSound);
        }
        
        // Démarrer l'enregistrement
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc, // Format de compression
            bitRate: 128000, // Qualité du son
          ),
          path: _recordingPath!,
        );
        
        _isRecording = true;
        return _recordingPath;
      }
    } catch (e) {
      print('Erreur lors du démarrage de l\'enregistrement: $e');
    }
    return null;
  }
  
  /// Arrête l'enregistrement
  /// Retourne le chemin du fichier enregistré
  Future<String?> stopRecording() async {
    try {
      // Arrêter l'enregistrement
      final path = await _audioRecorder.stop();
      
      // Arrêter le son d'ambiance
      await _ambiancePlayer.stop();
      
      _isRecording = false;
      _recordingPath = path;
      
      return path;
    } catch (e) {
      print('Erreur lors de l\'arrêt de l\'enregistrement: $e');
    }
    return null;
  }
  
  /// Joue un son d'ambiance en boucle
  Future<void> _playAmbianceSound(String ambiance) async {
    try {
      String soundPath;
      
      // Choisir le bon fichier son selon l'ambiance
      switch (ambiance) {
        case 'Salle':
          soundPath = 'assets/ambiance_sounds/classroom.mp3';
          break;
        case 'Auditorium':
          soundPath = 'assets/ambiance_sounds/auditorium.mp3';
          break;
        default:
          return; // Pas de son pour "Silencieux"
      }
      
      // Jouer le son en boucle
      await _ambiancePlayer.play(
        AssetSource(soundPath),
        volume: 0.3, // Volume à 30% pour ne pas couvrir la voix
      );
      await _ambiancePlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('Erreur lors de la lecture du son d\'ambiance: $e');
    }
  }
  
  /// Nettoyer les ressources quand on n'en a plus besoin
  Future<void> dispose() async {
    await _audioRecorder.dispose();
    await _ambiancePlayer.dispose();
  }
}
