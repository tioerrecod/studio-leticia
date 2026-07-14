import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final service = AuthService();
  ref.onDispose(() => service.signOut());
  return service;
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final auth = ref.watch(authServiceProvider);
  
  return Stream<AppUser?>.periodic(
    const Duration(seconds: 1),
    (_) => auth.currentUser,
  ).distinct((a, b) => a?.id == b?.id);
});
