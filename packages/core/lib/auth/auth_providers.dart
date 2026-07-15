import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';
import 'auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final service = AuthService();
  ref.onDispose(() => service.signOut());
  return service;
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final auth = ref.watch(authServiceProvider);
  final controller = StreamController<AppUser?>();

  controller.add(auth.currentUser);

  final sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final session = data.session;
    if (session != null) {
      auth.initialize().then((_) {
        if (!controller.isClosed) {
          controller.add(auth.currentUser);
        }
      });
    } else {
      if (!controller.isClosed) {
        controller.add(null);
      }
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
