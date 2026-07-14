class SupabaseConfig {
  const SupabaseConfig._();

  // ── Environment ───────────────────────────────────────
  // Replace with real values from .env file in production
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key-here',
  );

  // ── Table Names ───────────────────────────────────────
  static const String studios = 'studios';
  static const String users = 'users';
  static const String professionals = 'professionals';
  static const String services = 'services';
  static const String appointments = 'appointments';
  static const String experiences = 'experiences';
  static const String loyalty = 'loyalty';
  static const String memories = 'memories';
  static const String campaigns = 'campaigns';
}
