import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/account_providers.dart';
import '../../theme/tokens.dart';
import 'widgets/account_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('OneUp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(accountsProvider);
        },
        child: accountsAsync.when(
          data: (accounts) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: AppTokens.s16),
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTokens.s16),
                  child: Text(
                    'My Savings Accounts',
                    style: AppTokens.title.copyWith(
                      color: AppTokens.navy,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppTokens.s16),

                // Account cards
                ...accounts.map((account) => AccountCard(account: account)),

                const SizedBox(height: AppTokens.s24),

                // Info section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTokens.s32),
                  child: Text(
                    'Tip: Create a jar to start saving towards your goals!',
                    style: AppTokens.caption.copyWith(
                      color: AppTokens.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppTokens.s48),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.s24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTokens.errorRed,
                  ),
                  const SizedBox(height: AppTokens.s16),
                  Text(
                    'Failed to load accounts',
                    style: AppTokens.subtitle.copyWith(
                      color: AppTokens.errorRed,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s8),
                  Text(
                    '$err',
                    style: AppTokens.caption.copyWith(
                      color: AppTokens.gray500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
