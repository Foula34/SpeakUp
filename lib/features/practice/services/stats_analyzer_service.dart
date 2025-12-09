import 'package:just_audio/just_audio.dart';

/// Service qui analyse les enregistrements audio pour extraire des statistiques
/// C'est comme un "expert" qui écoute votre discours et vous donne des informations
class StatsAnalyzerService {
  // Liste des mots de remplissage à détecter (en français)
  static const List<String> fillerWords = [
    'euh',
    'heu',
    'donc',
    'alors',
    'voilà',
    'en fait',
    'du coup',
    'ben',
    'quoi',
    'genre',
  ];

  /// Analyse un fichier audio et retourne les statistiques
  /// Pour le MVP, on simule certaines statistiques car la vraie analyse vocale
  /// nécessiterait des services comme Google Speech-to-Text
  Future<SessionStats> analyzeRecording({
    required String audioPath,
    required int durationInSeconds,
  }) async {
    // Pour le MVP, on simule les statistiques
    // Dans une version future, on pourrait utiliser :
    // - Google Cloud Speech-to-Text pour la transcription
    // - Puis analyser le texte pour compter les mots et les fillers
    
    // Simulation basée sur la durée
    final wordsPerMinute = _estimateWordsPerMinute(durationInSeconds);
    final fillerCount = _estimateFillerCount(durationInSeconds);
    final pauseCount = _estimatePauseCount(durationInSeconds);
    
    return SessionStats(
      durationInSeconds: durationInSeconds,
      wordsPerMinute: wordsPerMinute,
      fillerCount: fillerCount,
      pauseCount: pauseCount,
    );
  }

  /// Estime le nombre de mots par minute (simulation pour le MVP)
  /// En moyenne, un discours clair fait 120-150 mots/min
  int _estimateWordsPerMinute(int duration) {
    // Simulation : entre 120 et 160 mots/min
    final baseRate = 140;
    final variance = (-10 + (duration % 20)).toInt();
    return baseRate + variance;
  }

  /// Estime le nombre de mots de remplissage (simulation)
  int _estimateFillerCount(int duration) {
    // Simulation : environ 2-3 fillers par minute
    final minutes = duration / 60;
    final baseFillers = (minutes * 2.5).round();
    final variance = duration % 3;
    return baseFillers + variance;
  }

  /// Estime le nombre de pauses longues (simulation)
  int _estimatePauseCount(int duration) {
    // Simulation : environ 1-2 pauses longues par minute
    final minutes = duration / 60;
    final basePauses = (minutes * 1.5).round();
    return basePauses;
  }

  /// Génère des conseils basés sur les statistiques
  SessionAdvice generateAdvice(SessionStats stats) {
    String title = '';
    String description = '';

    // Analyser le débit (mots/min)
    if (stats.wordsPerMinute < 120) {
      title = 'Accélérez un peu !';
      description =
          'Votre débit est un peu lent (${stats.wordsPerMinute} mots/min). Essayez de parler un peu plus vite pour maintenir l\'attention.';
    } else if (stats.wordsPerMinute > 160) {
      title = 'Ralentissez légèrement !';
      description =
          'Votre débit est rapide (${stats.wordsPerMinute} mots/min). Prenez le temps d\'articuler pour que votre audience suive bien.';
    } else {
      title = 'Excellent rythme !';
      description =
          'Votre débit (${stats.wordsPerMinute} mots/min) est dans la plage idéale. Continuez ainsi !';
    }

    // Ajouter un conseil sur les fillers si nécessaire
    if (stats.fillerCount > 5) {
      description +=
          ' Essayez de réduire les mots de remplissage (${stats.fillerCount} détectés) pour plus d\'impact.';
    } else if (stats.fillerCount == 0) {
      description += ' Aucun mot de remplissage détecté, excellent travail !';
    }

    return SessionAdvice(
      title: title,
      description: description,
    );
  }
}

/// Classe qui contient les statistiques d'une session
class SessionStats {
  final int durationInSeconds;
  final int wordsPerMinute;
  final int fillerCount;
  final int pauseCount;

  SessionStats({
    required this.durationInSeconds,
    required this.wordsPerMinute,
    required this.fillerCount,
    required this.pauseCount,
  });

  /// Formatte la durée en format MM:SS
  String get formattedDuration {
    final minutes = durationInSeconds ~/ 60;
    final seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} min';
  }
}

/// Classe qui contient les conseils pour l'utilisateur
class SessionAdvice {
  final String title;
  final String description;

  SessionAdvice({
    required this.title,
    required this.description,
  });
}
