import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_config.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthRepository.restoreSession();

  runApp(
    const ProviderScope(
      child: HerbiSenseApp(),
    ),
  );
}

class HerbiSenseApp extends ConsumerWidget {
  const HerbiSenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
