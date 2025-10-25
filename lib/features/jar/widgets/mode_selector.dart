import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/jar_v2.dart';
import '../../../state/jar_providers.dart';
import '../../../theme/tokens.dart';
import '../modals/tip_sheet.dart';

class ModeSelector extends ConsumerWidget {
  const ModeSelector({super.key, required this.jar});

  final JarV2 jar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saving Mode',
                  style: AppTokens.label.copyWith(color: AppTokens.gray700),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20),
                  onPressed: () => _showTipSheet(context, jar.savingMode),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.s12),

            SegmentedButton<SavingMode>(
              segments: const [
                ButtonSegment(
                  value: SavingMode.manual,
                  label: Text('💰 Manual'),
                ),
                ButtonSegment(
                  value: SavingMode.autoSave,
                  label: Text('🤖 Auto-Save'),
                ),
                ButtonSegment(
                  value: SavingMode.brandCoupons,
                  label: Text('🎟️ Coupons'),
                ),
              ],
              selected: {jar.savingMode},
              onSelectionChanged: (Set<SavingMode> newSelection) {
                ref.read(jarsProvider.notifier).updateMode(
                      jar.id,
                      newSelection.first,
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTipSheet(BuildContext context, SavingMode mode) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TipSheet(mode: mode),
    );
  }
}
