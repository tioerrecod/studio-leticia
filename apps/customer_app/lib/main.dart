import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:core/config/supabase_config.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    // ignore: deprecated_member_use
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: StudioLeticiaCustomerApp()));
}
