import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/tokens.dart';
import '../../app_router.dart';
import 'widgets/section_list.dart';

class AllScreen extends ConsumerWidget {
  const AllScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search - Coming soon!')),
              );
            },
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.settings);
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppTokens.s16),
        child: SectionList(),
      ),
    );
  }
}
