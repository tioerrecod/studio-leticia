import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'router/router.dart';

class BeautyCommandCenterApp extends ConsumerWidget {
  const BeautyCommandCenterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Beauty Command Center',
      debugShowCheckedModeBanner: false,
      theme: StudioTheme.light,
      routerConfig: router,
    );
  }
}
