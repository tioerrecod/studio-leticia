import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'router/router.dart';

class StudioLeticiaCustomerApp extends ConsumerWidget {
  const StudioLeticiaCustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Studio Letícia',
      debugShowCheckedModeBanner: false,
      theme: StudioTheme.dark,
      routerConfig: router,
    );
  }
}
