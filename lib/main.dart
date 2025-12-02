import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dmcyyzuvemgfrhvlewrg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRtY3l5enV2ZW1nZnJodmxld3JnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MTYyMTQsImV4cCI6MjA3OTM5MjIxNH0.eEvqcCp5czGUjAGsgVFhYZ8L8e8wIJVArZeCqlFejWU',
  );

  runApp(const ProviderScope(child: SpeakUpApp()));
}
