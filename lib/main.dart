import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'app_router.dart';
import 'core/services/storage_service.dart';
import 'state/app_providers.dart';
import 'state/providers.dart' show themeModeProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storage = StorageService();
  await storage.init();

  // Check onboarding status
  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
      ],
      child: OneUpApp(showOnboarding: !onboardingComplete),
    ),
  );
}

class OneUpApp extends ConsumerWidget {
  const OneUpApp({super.key, required this.showOnboarding});

  final bool showOnboarding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeString = ref.watch(themeModeProvider);

    // Convert String to ThemeMode enum
    final themeMode = switch (themeModeString) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return MaterialApp(
      title: 'OneUp',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,

      // Routing
      initialRoute: showOnboarding ? AppRouter.onboarding : AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
