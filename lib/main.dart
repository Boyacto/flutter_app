import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'app_router.dart';
import 'core/services/storage_service.dart';
import 'state/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storage = StorageService();
  await storage.init();

  // Check if first launch
  final isFirstLaunch = storage.isFirstLaunch();

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
      ],
      child: SavingJarApp(isFirstLaunch: isFirstLaunch),
    ),
  );
}

class SavingJarApp extends ConsumerWidget {
  final bool isFirstLaunch;

  const SavingJarApp({
    super.key,
    required this.isFirstLaunch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Saving Jar',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _getThemeMode(themeMode),

      // Routing
      initialRoute: AppRouter.getInitialRoute(isFirstLaunch),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
