import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_app/main.dart';
import 'package:flutter_app/core/services/storage_service.dart';
import 'package:flutter_app/state/app_providers.dart';

void main() {
  testWidgets('OneUp app smoke test', (WidgetTester tester) async {
    // Initialize storage for testing
    final storage = StorageService();
    await storage.init();

    // Build our app and trigger a frame
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
        ],
        child: const OneUpApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the home screen is displayed
    expect(find.text('OneUp'), findsOneWidget);
  });
}
