import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/jar/jar_detail_screen.dart';
import 'features/game/game_screen.dart';

/// App routing configuration
class AppRouter {
  AppRouter._();

  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String settings = '/settings';
  static const String jarDetail = '/jar-detail';
  static const String game = '/game';

  /// Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case '/':
        return MaterialPageRoute(builder: (_) => const AppShell());

      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case '/jar-detail':
        // Note: JarDetailScreen uses selectedJarProvider for jar ID
        return MaterialPageRoute(
          builder: (_) => const JarDetailScreen(),
        );

      case '/game':
        final gameId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => GameScreen(gameId: gameId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Get initial route
  static String getInitialRoute() {
    // Note: Onboarding check is handled in main.dart
    // This is just the default route
    return home;
  }
}
