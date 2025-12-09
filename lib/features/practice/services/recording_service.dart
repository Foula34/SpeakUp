import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  
  // L'audio enregistré en mémoire (pour le web)
  Uint8List? _recordingData;
  
  // Getters (pour lire les valeurs depuis l'extérieur)
  bool get isRecording => _isRecording;
  String? get recordingPath => _recordingPath;
  Uint8List? get recordingData => _recordingData;
  
  /// Démarre l'enregistrement audio
  /// Retourne le chemin du fichier ou null si erreur
  Future<String?> startRecording({String? ambianceSound}) async {
    try {
      // Vérifier si on a la permission d'enregistrer
      if (await _audioRecorder.hasPermission()) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        
        // Sur le web, enregistrer en mémoire
        if (kIsWeb) {
          _recordingPath = 'recording_$timestamp'; // Pseudo-chemin
          
          // Jouer le son d'ambiance si demandé
          if (ambianceSound != null && ambianceSound != 'Silencieux') {
            await _playAmbianceSound(ambianceSound);
          }
          
          // Démarrer l'enregistrement EN MÉMOIRE
          // Sur le web, on doit passer un chemin, mais les données sont en mémoire
          await _audioRecorder.start(
            const RecordConfig(
              encoder: AudioEncoder.pcm16bits,
            ),
            path: _recordingPath!,
          );
          _isRecording = true;
          return _recordingPath;
        } else {
          // Sur mobile/desktop, utiliser le système de fichiers
          final directory = await getApplicationDocumentsDirectory();
          _recordingPath = '${directory.path}/recording_$timestamp.m4a';
          
          // Jouer le son d'ambiance si demandé
          if (ambianceSound != null && ambianceSound != 'Silencieux') {
            await _playAmbianceSound(ambianceSound);
          }
          
          // Démarrer l'enregistrement
          await _audioRecorder.start(
            const RecordConfig(
              encoder: AudioEncoder.aacLc,
              bitRate: 128000,
            ),
            path: _recordingPath!,
          );
          
          _isRecording = true;
          return _recordingPath;
        }
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
      
      // Sur le web, récupérer les données en mémoire
      if (kIsWeb && path != null) {
        try {
          // Convertir le chemin en données audio (base64)
          _recordingData = base64.decode(path);
        } catch (e) {
          print('Erreur lors du décodage de l\'audio: $e');
          // path contient déjà les données, pas besoin de décoder
          _recordingData = utf8.encode(path) as Uint8List?;
        }
      }
      
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
