import 'package:flutter/foundation.dart';

class SupabaseConfig {
  SupabaseConfig._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://iwtqgxqpblmvahzsnnge.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3dHFneHFwYmxtdmFoenNubmdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQwMTA0MjgsImV4cCI6MjA5OTU4NjQyOH0.db7sJpHNFLe_RicYD14u322NverDHgL9ss1EKtwZ3-I',
  );

  static bool get isConfigured =>
      supabaseUrl != 'https://your-project.supabase.co' &&
      supabaseAnonKey != 'your-anon-key';

  static void debugPrintConfig() {
    if (kDebugMode) {
      print('Supabase Config:');
      print('  URL: $supabaseUrl');
      print('  Anon Key: ${supabaseAnonKey.substring(0, 20)}...');
      print('  Configured: $isConfigured');
    }
  }
}