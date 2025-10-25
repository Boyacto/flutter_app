import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/tokens.dart';
import '../../state/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final reduceMotion = ref.watch(reduceMotionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Language
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(locale.startsWith('ko') ? 'Korean' : 'English'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref, locale),
          ),

          const Divider(),

          // Theme
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle: Text(_getThemeLabel(themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeDialog(context, ref, themeMode),
          ),

          const Divider(),

          // Reduce motion
          SwitchListTile(
            value: reduceMotion,
            onChanged: (_) => ref.read(reduceMotionProvider.notifier).toggle(),
            secondary: const Icon(Icons.accessibility),
            title: const Text('Reduce Motion'),
            subtitle: const Text('Minimize animations for accessibility'),
          ),

          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () => _showAboutDialog(context),
          ),

          const Divider(),

          // Reset data
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppTokens.errorRed),
            title: const Text('Reset All Data', style: TextStyle(color: AppTokens.errorRed)),
            subtitle: const Text('Clear jar, events, and settings'),
            onTap: () => _showResetDialog(context, ref),
          ),
        ],
      ),
    );
  }

  String _getThemeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              value: 'en_US',
              groupValue: current,
              title: const Text('English'),
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              value: 'ko_KR',
              groupValue: current,
              title: const Text('한국어 (Korean)'),
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              value: 'system',
              groupValue: current,
              title: const Text('System'),
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              value: 'light',
              groupValue: current,
              title: const Text('Light'),
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              value: 'dark',
              groupValue: current,
              title: const Text('Dark'),
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Saving Jar',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.savings, size: 48, color: AppTokens.mint600),
      children: [
        const Text('A demo app for round-up savings with mock Capital One API integration.'),
        const SizedBox(height: 16),
        const Text('Built with Flutter & Riverpod'),
      ],
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will clear your jar, all events, and reset settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Reset jar
              ref.read(jarProvider.notifier).reset();
              // Clear events
              ref.read(eventsProvider.notifier).clearAll();
              // Reset settings
              ref.read(localeProvider.notifier).setLocale('en_US');
              ref.read(themeModeProvider.notifier).setThemeMode('system');
              ref.read(reduceMotionProvider.notifier).setValue(false);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data has been reset')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTokens.errorRed),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
