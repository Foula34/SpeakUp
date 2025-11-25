import 'package:flutter/material.dart';
import 'core/app.dart';

/// Point d'entrée de l'application SpeakUp
/// Initialisation de Supabase et lancement de l'app
void main() async {
  // Assure que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Initialiser Supabase ici
  // await Supabase.initialize(
  //   url: 'VOTRE_SUPABASE_URL',
  //   anonKey: 'VOTRE_SUPABASE_ANON_KEY',
  // );
  
  runApp(const SpeakUpApp());
}
