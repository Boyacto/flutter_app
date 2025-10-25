import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/tokens.dart';

class AllScreen extends ConsumerWidget {
  const AllScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📞 All'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTokens.s24),
          child: Text('All screen - Coming soon'),
        ),
      ),
    );
  }
}
