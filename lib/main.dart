import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app.dart';

/// Point d'entrée de l'application SpeakUp
/// 
/// Initialisation :
/// 1. Flutter bindings
/// 2. Supabase (TODO: à implémenter)
/// 3. Riverpod (state management)
/// 
/// TODO SUPABASE (pour ton collègue) :
/// Décommenter et configurer l'initialisation de Supabase :
/// 
/// ```dart
/// import 'package:supabase_flutter/supabase_flutter.dart';
/// 
/// await Supabase.initialize(
///   url: 'https://VOTRE_PROJECT_ID.supabase.co',
///   anonKey: 'VOTRE_ANON_KEY',
/// );
/// ```
/// 
/// Les clés Supabase se trouvent dans :
/// Dashboard Supabase → Settings → API → Project URL et anon/public key
void main() async {
  // Assure que les bindings Flutter sont initialisés avant toute opération async
  WidgetsFlutterBinding.ensureInitialized();
  
  // ========== INITIALISATION SUPABASE ==========
  // TODO SUPABASE : Décommenter et ajouter vos clés
  // await Supabase.initialize(
  //   url: 'VOTRE_SUPABASE_URL',
  //   anonKey: 'VOTRE_SUPABASE_ANON_KEY',
  //   authOptions: const FlutterAuthClientOptions(
  //     authFlowType: AuthFlowType.pkce, // Sécurité renforcée
  //   ),
  // );
  
  // Lancement de l'application avec Riverpod pour la gestion d'état
  runApp(
    const ProviderScope(
      child: SpeakUpApp(),
    ),
  );
}
