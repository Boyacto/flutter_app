import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';
import 'features/activity/activity_screen.dart';
import 'features/rules/rules_screen.dart';
import 'features/goal/goal_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/simulate/simulate_screen.dart';

/// App routing configuration
class AppRouter {
  AppRouter._();

  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String activity = '/activity';
  static const String rules = '/rules';
  static const String goal = '/goal';
  static const String settings = '/settings';
  static const String simulate = '/simulate';

  /// Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/activity':
        return MaterialPageRoute(builder: (_) => const ActivityScreen());
      case '/rules':
        return MaterialPageRoute(builder: (_) => const RulesScreen());
      case '/goal':
        return MaterialPageRoute(builder: (_) => const GoalScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/simulate':
        return MaterialPageRoute(builder: (_) => const SimulateScreen());
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

  /// Get initial route based on whether it's first launch
  static String getInitialRoute(bool isFirstLaunch) {
    return isFirstLaunch ? onboarding : home;
  }
}
