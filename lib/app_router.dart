import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/jar/jar_detail_screen.dart';

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
        final jarId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => JarDetailScreen(jarId: jarId),
        );

      case '/game':
        // return MaterialPageRoute(builder: (_) => const GameScreen());
        // TODO: Implement game screen
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Game - Coming soon')),
          ),
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
    // For hackathon, skip onboarding
    return home;
  }
}
